require 'nokogiri'
require 'open-uri'
require 'net/http'

class BookScraperJob < ApplicationJob
  queue_as :default

  attr_reader :book_title, :book_author, :book_author_link, :book_url, :book_cover, :book_description, :book_pages, :book_format, :publication_year

  def perform(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    doc = Nokogiri::HTML(response.body)

    doc.css('table tr').each do |tr|
      get_basic_book_info(tr)
      get_author_info(tr)
      get_book_info
      author_generator
      book_generator
      puts Book.all
      puts Author.all
      puts Genre.all
    end
  end

  def get_basic_book_info(tr)
    @book_title = tr.at_css('.bookTitle span[itemprop="name"]')&.text
    book_link = book_url_element = tr.at_css('.bookTitle[itemprop="url"]')
    @book_url = "https://www.goodreads.com" + book_url_element['href']
  end
  
  def get_author_info(tr)
    @author_name = tr.at_css('.authorName').children.text
    author_link_element = tr.at_css('.authorName__container a[itemprop="url"]')
    book_author_link = author_link_element['href']

    author_scraper(book_author_link)
  end

  def get_book_info
    book_doc = Nokogiri::HTML(URI.open(@book_url))
    book_card = book_doc.at_css('.BookCard')

    if book_card
      book_cover_element = book_card.at_css('.BookCover__image img')
      if book_cover_element
        @book_cover = book_cover_element['src']
      end
  
      description_element = book_doc.at_css('.BookPageMetadataSection__description .Formatted')
      if description_element
        @book_description = description_element.text.strip
      end
  
      pages_format_element = book_doc.at_css('.BookDetails .CollapsableList [data-testid="pagesFormat"]')
      if pages_format_element
        pages_format = pages_format_element.text.strip.split(" ")
        @book_pages = pages_format[0]
        @book_format = pages_format[2]
      end
  
      publication_info_element = book_doc.at_css('.BookDetails .CollapsableList [data-testid="publicationInfo"]')
      if publication_info_element
        @publication_year =  publication_info_element.text.strip.split(",")[-1]
      end
    end
  end

  def author_scraper(book_author_link)
    author_doc = Nokogiri::HTML(URI.open(book_author_link))
    genre_generator(author_doc)
    
    author_photo_element = author_doc.at_css('.leftContainer.authorLeftContainer img[itemprop="image"]')
    @author_photo_url = author_photo_element['src'] if author_photo_element

    author_bio_element = author_doc.at_css('.aboutAuthorInfo span[id^="freeTextContainerauthor"]')
    @author_about = author_bio_element&.text.strip if author_bio_element
  end

  def author_generator
    author = Author.find_by(name: @author_name)
          
    if author.nil?
      @author = Author.new(
        name: @author_name,
        about: @author_about,
        photo: @author_photo_url,
      )
      # @genres_array.each do |genre|
      #   genre = AuthorGenre.find_or_create_by(name: genre)
      #   genre.update(author_id: @author.id, genre_id: genre.id)
      #   @author.genres << genre
      # end
      @author.save!
    else
      ""
    end
  end

  def genre_generator(author_doc)
    genre_element = author_doc.at_css('.dataTitle:contains("Genre")')
    @genres_array = genre_element.next_element.css('a').map(&:text)

    @genres_array.each do |genre|
      genre = Genre.find_or_create_by(name: genre)
    end
  end
  
  def book_generator
    book = Book.find_by(title: @book_title)

    if book.nil?
      book = Book.create(
        title: @book_title,
        author_id: @author.id,
        description: @book_description,
        cover_image: @book_cover,
        year: @publication_year,
        price: 0.0,
        genre_id: 1
      )
      @genres_array.each do |genre|
        genre = Genre.find_or_create_by(name: genre)
        genre.update(book_id: book.id, genre_id: genre.id)
        book.genres << genre
      end
    else
      puts "Book already exists: #{book_title}"
    end
  end
end
