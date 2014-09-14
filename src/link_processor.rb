require 'nokogiri'
require 'open-uri'

class LinkProcessor
  def process(url)
    begin
      Nokogiri::HTML(open(url))
      rescue OpenURI::HTTPError, TypeError => e
        warn "Failed to get content for #{url} - #{e}"
        Nokogiri::HTML::Document.new
    end
  end
end