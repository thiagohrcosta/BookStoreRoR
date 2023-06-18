require 'nokogiri'
require 'open-uri'
require 'net/http'

class BookScraperJob < ApplicationJob
  queue_as :default

  attr_reader :book_title, :book_author, :book_author_link, :book_url, :book_cover, :book_description

  def perform(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    doc = Nokogiri::HTML(response.body)

    doc.css('table tr').each do |tr|
      get_basic_book_info(tr)
      get_book_info(@book_url)
      puts "Title: #{book_title}"
      puts "Author: #{book_author}"
      puts "Author Link: #{book_author_link}"
      puts "Book URL: #{book_url}"
    end
  end

  def get_basic_book_info(tr)
    @book_title = tr.at_css('.bookTitle span[itemprop="name"]')&.text
    @book_author = tr.at_css('.authorName span[itemprop="name"]')&.text
    @book_author_link = tr.at_css('.authorName span[itemprop="name"] a')&.attributes['href']&.value

    book_link = tr.at_css('.bookTitle span[itemprop="name"] a')&.attributes['href']&.value
    @book_url = "https://www.goodreads.com#{book_link}"
  end

  def get_book_info(book_url)
    # need to scrap now the book_url
    doc = Nokogiri::HTML(URI.open(book_url))
    book_card = doc.at_css('.BookCard')
    if book_card
      @book_cover = book_card.at_css('.BookCover__image img')&.[]('src')
      puts "Cover: #{book_cover}"
    end

    description_element = doc.at_css('.BookPageMetadataSection__description .Formatted')
    if description_element
      @book_description = description_element.text.strip
      puts "Description: #{book_description}"
    end

    pages_format_element = doc.at_css('.BookDetails .CollapsableList [data-testid="pagesFormat"]')
    if pages_format_element
      @pages_format = pages_format_element.text.strip
      puts "Pages Format: #{pages_format}"
    end

    publication_info_element = doc.at_css('.BookDetails .CollapsableList [data-testid="publicationInfo"]')
    if publication_info_element
      @publication_info = publication_info_element.text.strip
      puts "Publication Info: #{publication_info}"
    end
  end
end
