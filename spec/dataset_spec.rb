require 'spec_helper'
require 'ckan_fakeweb'

describe DataKitten::Dataset do

  before :all do
    FakeWeb.clean_registry
    FakeWeb.allow_net_connect = false
  end

  describe 'with a supported format' do
    it 'returns the original source' do
      datapackage = load_fixture("datapackage.json")
      FakeWeb.register_uri(:get, "http://example.org/datapackage.json", :body => datapackage, :content_type => "application/json")
      dataset = DataKitten::Dataset.new( access_url: "http://example.org/datapackage.json")
      source = JSON.parse(datapackage)
      expect(dataset.source).to eql(source)
    end

    it 'returns the ckan api source after lookup' do
      url = CKANFakeweb.register_defence_dataset
      data = JSON.parse(load_fixture("ckan/rest-dataset-defence.json"))
      dataset = DataKitten::Dataset.new(access_url: "http://example.org/dataset/defence")
      expect(dataset.source).to eql(data)
    end
  end

  describe 'with an unsupported format' do
    before do
      FakeWeb.register_uri(:get, "http://example.org/something.html", :body => "", :content_type => "text/html")
      @dataset = DataKitten::Dataset.new( access_url: "http://example.org/something.html")
    end

    it 'returns nil' do
      expect( @dataset.source ).to be_nil
    end
  end

  describe 'when resource does not exist' do
    before do
      FakeWeb.register_uri(:get, "http://example.org/something.html", :body => "Not found", :status => [404, "Not found"])
      @dataset = DataKitten::Dataset.new( access_url: "http://example.org/something.html")
    end

    it 'returns nil' do
      expect( @dataset.source ).to be_nil
    end
  end

end
