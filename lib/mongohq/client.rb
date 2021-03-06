require 'httparty'

# @author Martin Wawrusch
#
# An API wrapper for the http://mongohq.com API
# @see Client Client documentation for examples how to use the API.
module Mongohq
  # The client to access the API.
  # @example Create a database
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.create_database 'mydatabase','micro'
  #
  # @example Get list of datbases
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.databases()
  #
  # @example Get info about a database
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.database('angelina')
  #
  # @example Get a list of collections
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.collections('angelina')
  #
  # @example Create a collection
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.create_collection('angelina','test')
  #
  # @example Rename a collection
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.rename_collection('angelina','test','test1')
  #
  # @example Get collection info
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.collection('angelina','test')
  #
  # @example Delete a collection
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.delete_collection('angelina','test')
  #
  # @example Query for documents (see method description for more options)
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.documents('angelina','test')
  #
  # @example Query for documents with limit
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.documents('angelina','test', {:limit=>1})
  #
  # @example Create a document
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.create_document('angelina','test',"{'name' : 'blah'}")
  #
  # @example Update a document
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.update_document('angelina','test','4e36dbd15163dd5b82000004',"{'name' : 'blah 1'}")
  #
  # @example Get a document
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.document('angelina','test','4e36dbd15163dd5b82000004')
  #
  # @example Delete a document
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.delete_document('angelina','test','4e36dbd15163dd5b82000004')
  #
  # @example Delete a database
  #   client = Mongohq::Client.new("arthur","dent")
  #   client.delete_database('angelina')
  #
  class Client
    include HTTParty
    base_uri 'https://mongohq.com/api'

    # Inititalizer for the client class. 
    # @param [String] api_key the api_key name of your mongohq.com account.
    # @param [String] api_secret the api_secret of your mongohq.com account.
    # @return [Client] a new instance of the client.
    def initialize(api_key, api_secret )
      @auth = {:username => api_key, :password => api_secret}
    end
       
private
   
    # Examines a bad response and raises an appropriate exception
    #
    # @param [HTTParty::Response] the response as returned by the web request.
    # @raise [ResponseError] raised in case of a web service related error.
    # @raise [StandardError] raised in case of an error that is not web service related. 
    # @return [HTTParty::Response] the response as returned by the web request.
    def bad_response(response)
      if response.class == HTTParty::Response
       raise ResponseError, response
      end
      raise StandardError, "Unkown error"
    end

    # Examines a response and either returns the response or
    # raise an exception.
    # @param [HTTParty::Response] the response as returned by the web request.
    # @raise [ResponseError] raised in case of a web service related error.
    # @raise [StandardError] raised in case of an error that is not web service related. 
    # @return [HTTParty::Response] the response as returned by the web request.
    def handle_result(response)
      #puts response.inspect
      response.ok? ? response : bad_response(response) 
    end

public  

    # Returns a list of all databases.
    # @return [HTTParty::Response] A response.
    #   An array containing a list of database hashes
    #   * name
    #   * hostname
    #   * port
    def databases()
      options={:basic_auth => @auth}
      handle_result self.class.get('/databases', options)
    end

    # Returns the connection detail for a database
    # This is a simple wrapper over databases, which should be used if you need connection info
    # for more than one 
    # @return [Hash] A hash containing .
    #   * name
    #   * hostname
    #   * port
    def database_connection_detail(name)
      res = databases()
      items = res.select {|x| x['name'] == name}
      
      raise StandardError, "Database #{name} not found." unless items && items.length > 0
      items[0]
    end

    # Creates a new database
    # @param (String) name the name of the new database.
    # @param (String) db_type the type of the new database. Can be micro, small, large. Check mongohq.com for additional options
    # @return [HTTParty::Response] A response.
    def create_database(name,db_type)
      options={:basic_auth => @auth, :body => {:name => name,:db_type => db_type}}
      handle_result self.class.post("/databases", options)
    end

    # Deletes a database. This cannot be undone.
    # @param (String) database the name of the database.
    # @return [HTTParty::Response] A response.
    def delete_database(database)
      options={:basic_auth => @auth}
      handle_result self.class.delete("/databases/#{database}", options)
    end


    # Returns the database specific information
    # @param (String) database the name of the database.
    # @return [HTTParty::Response] A response.
    #   The database info as returned from mongodb
    def database(database)
      options={:basic_auth => @auth}
      handle_result self.class.get("/databases/#{database}", options)
    end
    
    
    # Returns a list of all collections belonging to the database.
    # @param (String) database the name of the database.
    # @return [HTTParty::Response] A response.
    #   An array containing a list of collections.
    def collections(database)
      options={:basic_auth => @auth}
      handle_result self.class.get("/databases/#{database}/collections", options)
    end

    
    # Creates a new collection
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @return [HTTParty::Response] A response.
    def create_collection(database,collection)
      options={:basic_auth => @auth, :body => {:name => collection}}
      handle_result self.class.post("/databases/#{database}/collections", options)
    end

    # Returns the collection specific information
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @return [HTTParty::Response] A response.
    #   The collection info as returned from mongodb
    def collection(database,collection)
      options={:basic_auth => @auth}
      handle_result self.class.get("/databases/#{database}/collections/#{collection}", options)
    end
    
    # Deletes the collection
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @return [HTTParty::Response] A response.
    def delete_collection(database,collection)
      options={:basic_auth => @auth}
      handle_result self.class.delete("/databases/#{database}/collections/#{collection}", options)
    end
    
    # Renames a new collection
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @param (String) new_name the new name of the collection.
    # @return [HTTParty::Response] A response.
    def rename_collection(database,collection,new_name)
      options={:basic_auth => @auth, :body => {:name => new_name}}
      handle_result self.class.put("/databases/#{database}/collections/#{collection}", options)
    end
    
    # Returns a list of all collections belonging to the database.
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @option opts [String] :q a JSON document to query your data with
    # @option opts [String] :fields aJSON array or hash describing the fields to return from the query
    # @option opts [String] :skip an integer with the number of documents to skip (allowing pagination)
    # @option opts [String] :limit the number of documents to return (defaults to 20, max of 100)
    # @option opts [String] :sort a JSON document describing how to sort the results
    # @return [HTTParty::Response A response.
    #   The json result from the query
    def documents(database,collection, opts = {})
      options={:basic_auth => @auth, :query => opts}
      handle_result self.class.get("/databases/#{database}/collections/#{collection}/documents", options)
    end

    # Returns a the document as specified through it's id
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @param (String) document_id the document_id of the document.
    # @return [HTTParty::Response A response.
    #   The json describing the document
    def document(database,collection, document_id)
      options={:basic_auth => @auth}
      handle_result self.class.get("/databases/#{database}/collections/#{collection}/documents/#{document_id}", options)
    end

    # Creates a new document
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @param (String) document_json a json string containing the new document
    # @return [HTTParty::Response A response.
    #   The created document
    def create_document(database,collection, document_json)
      options={:basic_auth => @auth,:body => {:document => document_json}}
      handle_result self.class.post("/databases/#{database}/collections/#{collection}/documents", options)
    end

    # Updates a new document
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @param (String) document_id the document_id of the document.
    # @param (String) document_json a json string containing the new document
    # @return [HTTParty::Response A response.
    #   The updated document
    def update_document(database,collection,document_id, document_json)
      options={:basic_auth => @auth,:body => {:document => document_json}}
      handle_result self.class.put("/databases/#{database}/collections/#{collection}/documents/#{document_id}", options)
    end


      
    # Deletes the document
    # @param (String) database the name of the database.
    # @param (String) collection the name of the collection.
    # @param (String) document_id the document_id of the document.
    # @return [HTTParty::Response A response.
    def delete_document(database,collection, document_id)
      options={:basic_auth => @auth}
      handle_result self.class.delete("/databases/#{database}/collections/#{collection}/documents/#{document_id}", options)
    end
      
  end
end

