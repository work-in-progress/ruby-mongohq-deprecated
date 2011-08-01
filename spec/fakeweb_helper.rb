require 'fakeweb'

FakeWeb.allow_net_connect = false

def stub_file(stub)
  File.join(File.dirname(__FILE__), 'stubs', stub)
end

def fake_it_all
  FakeWeb.clean_registry
  #FakeWeb.register_uri :head, %r{http://(api.)|(www.)?mongohq.com(/items)?}, :status => ["200", "OK"]
 
  {
    # GET URLs
    :get => {
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections' => 'get_collections',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test' => 'get_collections_test',
      'https://arthur:dent@mongohq.com/api/databases' => 'get_databases',
      'https://arthur:dent@mongohq.com/api/databases/angelina' => 'get_databases_angelina',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test/documents' => 'get_documents',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004' => 'get_documents_4e36c1535163dd2752000004'
    },
    # POST URLs
    :post => {
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections' => 'post_collections',
      'https://arthur:dent@mongohq.com/api/databases' => 'post_databases',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test/documents' => 'post_documents'
    },
    # PUT URLs
    :put => {
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test' => 'put_collections_test',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004' => 'put_documents_4e36c1535163dd2752000004'
    },
    # DELETE URLs
    :delete => {
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test' => 'delete_collections_test',
      'https://arthur:dent@mongohq.com/api/databases/angelina' => 'delete_databases_angelina',
      'https://arthur:dent@mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004' => 'delete_documents_4e36c1535163dd2752000004'
    }
  }.each do |method, requests|
    requests.each do |url, response|
      FakeWeb.register_uri(method, url, :response => stub_file(response))
    end
  end
end

