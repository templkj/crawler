require 'monitor'
require 'thread'
require_relative 'link_processor'
require_relative 'page'

class Crawler

  def initialize (seed)
    @seed = seed
    @linkProcessor = LinkProcessor.new
    @urlsToFilter = Set.new
    @queue = Queue.new
    queue_url(seed)
  end

  def execute
    pages = Set.new

    while(@queue.length>0) do
      link = @queue.pop
      downloadedPage = Page.new(link, @linkProcessor.process(link))
      pages << downloadedPage
      downloadedPageUri = URI(link)
      downloadedPage.links.each do |linkOnPage|

        linkOnPageUri = reconstruct_relativeUrl(downloadedPageUri, linkOnPage)

        if (is_to_be_processed?(downloadedPageUri, linkOnPageUri))
          linkString = linkOnPageUri.to_s
          @queue << linkString
          queue_url(linkString)
        end

      end

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

  def queue_url(linkString)
    @queue << linkString
    update_filter(linkString)
  end

  def update_filter(linkString)
    @urlsToFilter << linkString
    @urlsToFilter << linkString + '/' if !linkString.end_with?('/')
    @urlsToFilter << linkString[0..-1] if linkString.end_with?('/')
  end

  def is_to_be_processed?(downloadedPageUri, linkOnPageUri)
    (linkOnPageUri.host == downloadedPageUri.host) &&
        (linkOnPageUri.scheme == downloadedPageUri.scheme) &&
        (!@urlsToFilter.include? linkOnPageUri.to_s)
  end

  def reconstruct_relativeUrl(uriContainingHost, linkString)
    begin
      newLinkUri = URI(linkString)
      if !newLinkUri.host
        reconstructedUri = URI(uriContainingHost.scheme + '://' + uriContainingHost.host)
        newLinkUri = URI.join(reconstructedUri, linkString)
      end
      newLinkUri
    rescue
      warn "Unable to parse link:#{linkString} on page #{uriContainingHost}"
      uriContainingHost
    end

  end
end

