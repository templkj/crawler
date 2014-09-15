require 'monitor'
require 'thread'
require_relative 'link_processor'
require_relative 'page'
require_relative 'page_link_extractor'

class Crawler

  def initialize (seed)
    @seed = seed
    @linkProcessor = LinkProcessor.new
    @urlsToFilter = Set.new
    @queue = Queue.new
    @queue.push(seed)
    update_filter(seed)
  end

  def execute
    pages = Set.new

    while(@queue.length>0) do
      link = @queue.pop
      process_page(link, pages)
    end
    pages
  end

  #Probably want to move this elsewhere
  def json_output(set)
    set.each do |page|
      puts page.to_hash
    end
  end

  private

  def process_page(link, pages)
    downloadedPage = Page.new(link, @linkProcessor.process(link))
    pages << downloadedPage
    process_page_links(downloadedPage, link)
  end


  def process_page_links(downloadedPage, link)
    pageLinkProcessor = PageLinkExtractor.new(@urlsToFilter)
    links = pageLinkProcessor.extract_page_links_within_given_domain(downloadedPage, link)
    update_queue_and_filter_with(links)
  end

  def update_queue_and_filter_with(links)
    links.each do |pageLink|
      @queue.push(pageLink) unless @urlsToFilter.include?(pageLink)
      update_filter(pageLink.to_s)
    end
  end

  def update_filter(linkString)
    @urlsToFilter << linkString
    @urlsToFilter << linkString + '/' if !linkString.end_with?('/')
    @urlsToFilter << linkString[0..-1] if linkString.end_with?('/')
  end
end

