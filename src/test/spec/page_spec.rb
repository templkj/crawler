require 'rspec'
require_relative '../../page'
require 'nokogiri'

shared_examples_for 'a page' do
  describe 'standard page behaviour' do
    it 'should be immutable' do
      expect(page).to_not respond_to(:url=)
      expect(page).to_not respond_to(:assets=)
      expect(page).to_not respond_to(:links=)
    end
    it 'should have the right url' do
      expect(page.url).to eq(@url)
    end
    it 'should have the correct links' do
      expect(page).to respond_to(:links)
      expect(page.links).to be_an_instance_of(Set)
      expect(page.links.size).to eq(2)
      expect(page.links.include?('http://google.com')).to eq(true)
      expect(page.links.include?('http://boom.com')).to eq(true)
    end
    it 'should have the right static assets' do
      expect(page).to respond_to(:assets)
      expect(page.assets).to be_an_instance_of(Set)
      expect(page.assets.size).to eq(2)
      expect(page.assets.include?('anImage.jpg')).to eq(true)
      expect(page.assets.include?('css.css')).to eq(true)
    end
  end
end

describe Page do
  before do
    @url = 'http://example.com'
    @stringContent = '<html><head><link rel="stylesheet" type="text/css" href="css.css" /><body>A string of <img src="anImage.jpg"/>html<a href="http://google.com"/><a href="http://boom.com"/><a href="http://google.com"/></body></html>'
  end

  context 'Given a new Page with string content' do
    it_behaves_like 'a page' do
      let(:page) {Page.new(@url,@stringContent)}
    end
  end
  context 'Given a new Page with Nokogiri HTML content' do
    it_behaves_like 'a page' do
      let(:page) {Page.new(@url,Nokogiri::HTML(@stringContent))}
    end
  end
  context 'Given a new Page with Nokogiri XML content' do # just threw this in as it was obvious it would pass, but not used
    it_behaves_like 'a page' do
      let(:page) {Page.new(@url,Nokogiri::XML(@stringContent))}
    end
  end

end