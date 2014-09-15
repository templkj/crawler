require 'rspec'
require_relative '../../page_link_processor'
require_relative '../../page'

describe PageLinkProcessor do
  context 'given an empty url filter and a simple file' do
    before do
      @plp = PageLinkProcessor.new(Set.new)
      file = File.open(File.join(File.dirname(__FILE__), "../fixtures/example.com-with-one-internal-link.html"), 'rb')
      @standaloneWebsite = Page.new('http://example.com', file.read)
    end

    it 'should process the only valid url on the page' do
      results = @plp.extract_page_links_within_given_domain(@standaloneWebsite, @standaloneWebsite.url)
      expect(results.size).to eq(1)
      expect(results.first).to eq('http://example.com/resume.html')
    end
  end

  context 'given a simple file and a filter for all links' do
    before do
      @plp = PageLinkProcessor.new(['http://example.com/resume.html'])
      file = File.open(File.join(File.dirname(__FILE__), "../fixtures/example.com-with-one-internal-link.html"), 'rb')
      @standaloneWebsite = Page.new('http://example.com', file.read)
    end

    it 'should not return anything' do
      results = @plp.extract_page_links_within_given_domain(@standaloneWebsite, @standaloneWebsite.url)
      expect(results.size).to eq(0)
    end

    it 'should return 1 link when a different domain is given for where it was downloaded from' do
      results = @plp.extract_page_links_within_given_domain(@standaloneWebsite, 'http://twitter.com')
      expect(results.size).to eq(1)
      expect(results.first).to eq("http://twitter.com/aidmcg")

    end
  end

end