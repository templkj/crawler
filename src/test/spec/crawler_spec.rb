require 'rspec'
require_relative '../../crawler'
require 'fakeweb'
require 'json'

describe Crawler do
  before do
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = false
    file = File.open(File.join(File.dirname(__FILE__), "../fixtures/standalone-website.html"), 'rb')
    @standaloneWebsite =  file.read
    file = File.open(File.join(File.dirname(__FILE__),
                                                      "../fixtures/example.com-with-one-internal-link.html"), 'rb')
    @websiteWithOneInternalLink = file.read

  end
  after do
    FakeWeb.allow_net_connect = true
  end

  context 'single page site with no internal links' do
    before do
      @crawler = Crawler.new('http://simplepage.com')
      file = File.open(File.join(File.dirname(__FILE__), "../fixtures/standalone-website.html"), 'rb')
      @standaloneWebsite =  file.read
      FakeWeb.register_uri(:any, 'http://simplepage.com', :content_type => "text/html", :body => @standaloneWebsite)
    end

    it 'should return only the page passed in' do
      results = @crawler.execute
      expect(results.size).to eq(1)
      expect(results.include?(Page.new('http://simplepage.com', @standaloneWebsite))).to eq(true)
    end
  end

  context 'seeded with a site containing two accessible pages' do
    before do
      @crawler = Crawler.new('http://example.com')
      FakeWeb.register_uri(:any, 'http://example.com', :content_type => "text/html", :body => @websiteWithOneInternalLink)
      FakeWeb.register_uri(:any, 'http://example.com/resume.html', :content_type => "text/html", :body => @standaloneWebsite)
    end

    it 'should return the two pages' do
      results = @crawler.execute

      expect(results.size).to eq(2)
      expect(results.include?(Page.new('http://example.com', @websiteWithOneInternalLink))).to eq(true)
      expect(results.include?(Page.new('http://example.com/resume.html', @standaloneWebsite))).to eq(true)
    end
  end

end
