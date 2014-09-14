require 'rspec'
require_relative '../../link_processor'
require_relative '../../page'
require_relative '../../crawler'

describe 'Given I am connected to the internet' do

  context 'when I retrieve a document with the link processor' do
    before(:all) do
      @document = LinkProcessor.new.process 'http://google.com'
    end

    it 'should be parsed without errors by the page class' do
      page = Page.new('http://google.com', @document)

      expect(page.links.size).to_not eq(0)
      expect(page.assets.size).to_not eq(0)
    end
  end

  context 'lets hit gocardless....' do
    before do
      skip 'Extremely slow test thats certainly not very reliable'
      @crawler = Crawler.new('https://gocardless.com')
    end

    it 'should return 397 pages?' do
      results = @crawler.execute
      expect(results.size).to eq(397)
    end
  end


end