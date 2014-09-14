require 'nokogiri'

class Page
  attr_reader :url, :links, :assets

  def initialize(myUrl, myContent)
    @url = myUrl
    content = myContent.respond_to?(:xpath) ? myContent : Nokogiri::HTML(myContent)

    @links = parseAssets(content, LINK_FILTERS) # these should really be immutable
    @assets = parseAssets(content, ASSET_FILTERS)
  end

  def to_hash
    hash = Hash.new
    hash["url"] = @url
    hash["links"] = @links.to_a
    hash["assets"] = @assets.to_a
    hash
  end

  def ==(other)
    return other.url == @url && other.links == @links && other.assets == @assets
  end
  alias :eql? :==

  def hash
    return url.hash + @links.hash + @assets.hash
  end

  private

  LINK_FILTERS = ['//a/@href']
  ASSET_FILTERS = ['//img/@src', "//*[@type='text/css']/@href"]

  def parseAssets(document, filters)
    set = Set.new
    filters.each do |filter|
      set.merge document.xpath(filter).map { |link| link.to_s }
    end
    return set
  end
end