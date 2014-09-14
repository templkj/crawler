require 'rspec'
require_relative '../../link_processor'
require 'fakeweb'

describe LinkProcessor do
  before :each do
    @producer = LinkProcessor.new
    @exampleUrl = "http://example.com"
  end

  it 'should be able to process urls' do
    expect(@producer).to respond_to(:process).with(1).argument
  end


  context 'when processing an invalid url' do
    context 'url is null' do
      it "creates a Nokogiri XML document" do
        expect(@producer.process(nil)).to be_an_instance_of(Nokogiri::HTML::Document)
      end
      it 'should return an empty document' do
        expect(@producer.process(nil).inner_html).to eq("")
      end
    end
    context 'url request is not successful' do
      before do
        FakeWeb.register_uri(:any, @exampleUrl, :body => "Nothing to be found 'round here",
                             :status => ["404", "Not Found"])
      end
      it "creates a Nokogiri XML document" do
        expect(@producer.process(@exampleUrl)).to be_an_instance_of(Nokogiri::HTML::Document)
      end
      it 'should return an empty document' do
        expect(@producer.process(@exampleUrl).inner_html).to eq("")
      end
    end
  end

  context 'when processing a valid url' do
    before do
      FakeWeb.register_uri(:any, @exampleUrl, :content_type => "text/html", :body => '<p>Hello World</p>')
    end
    it "creates a Nokogiri XML document" do
      expect(@producer.process(@exampleUrl)).to be_an_instance_of(Nokogiri::HTML::Document)
    end
    it 'should return an empty document' do
      expect(@producer.process(@exampleUrl).inner_html).to eq("<html><body><p>Hello World</p></body></html>")
    end
  end

end