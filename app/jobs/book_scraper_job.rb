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
      get_book_info(@book_url)
      puts "Title: #{book_title}"
      puts "Author: #{book_author}"
      puts "Author Link: #{book_author_link}"
      puts "Book URL: #{book_url}"
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

  def get_book_info(book_url)
    book_doc = Nokogiri::HTML(URI.open(@book_url))
    book_card = book_doc.at_css('.BookCard')
    book_cover_element = book_card.at_css('.BookCover__image img')

    if book_cover_element
      @book_cover = book_cover_element['src']
    end

    description_element = book_doc.at_css('.BookPageMetadataSection__description .Formatted')
    if description_element
      @book_description = description_element.text.strip
      puts "Description: #{book_description}"
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

  def author_scraper(book_author_link)
    author_doc = Nokogiri::HTML(URI.open(book_author_link))
    binding.pry

    
  end

end
