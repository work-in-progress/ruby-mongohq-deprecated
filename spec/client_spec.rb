require 'spec_helper'
require 'mongohq'

describe Mongohq::Client do
  before(:each) do
    fake_it_all
    @client = Mongohq::Client.new("arthur","dent")
  end
  
  
  context "WHEN invoking GET https://mongohq.com/api/databases" do
    it "THEN it should return a list of databases" do
      res = @client.databases
      res.length.should == 5
      res[0]['name'].should == 'angelina'
      res[0]['port'].should == 1000
      res[0]['hostname'].should == 'swan.mongohq.com'
    end
  end

  context "WHEN invoking GET https://mongohq.com/api/databases through database_detail" do
    it "THEN it should return a list of databases" do
      res = @client.database_connection_detail 'angelina'
      res['name'].should == 'angelina'
      res['port'].should == 1000
      res['hostname'].should == 'swan.mongohq.com'
    end
  end
  
  

  context "WHEN invoking POST https://mongohq.com/api/databases" do
    it "THEN it should create a new database" do
      res = @client.create_database('angelina','micro')
      res['ok'].should == 1
      
    end  
  end

  context "WHEN invoking GET https://mongohq.com/api/databases/angelina" do
    it "THEN it should return details about the database" do
      res = @client.database('angelina')
    end
  end

  context "WHEN invoking DELETE https://mongohq.com/api/databases/angelina" do
    it "THEN it should delete the database" do
      res = @client.delete_database('angelina')
      res['ok'].should == 1
    end
  end

  context "WHEN invoking GET https://mongohq.com/api/databases/angelina/collections" do
    it "THEN it should return a list of collections" do
      res = @client.collections('angelina')
    end
  end

  context "WHEN invoking POST https://mongohq.com/api/databases/angelina/collections" do
    it "THEN it should create a new collection" do
      res = @client.create_collection('angelina','test')
    end  
  end

=begin
  context "WHEN invoking GET https://mongohq.com/api/databases/angelina/collections/test" do
    it "THEN it should return details about the collection" do
      res = @client.collection('angelina','test')
    end
  end
=end
  
  context "WHEN invoking PUT https://mongohq.com/api/databases/angelina/collections/test" do
    it "THEN it should rename the collection" do
      res = @client.rename_collection('angelina','test','test1')

    end
  end

  context "WHEN invoking DELETE https://mongohq.com/api/databases/angelina/collections/test" do
    it "THEN it should delete the collection" do
      res = @client.delete_collection('angelina','test')
      res['ok'].should == 1
    end
  end
  
  context "WHEN invoking GET https://mongohq.com/api/databases/angelina/collections/test/documents" do
    it "THEN it should return all documents in the collection" do
      res = @client.documents('angelina','test',{})
    end
  end

  context "WHEN invoking POST https://mongohq.com/api/databases/angelina/collections/test/documents" do
    it "THEN it should create a new document" do
      res = @client.create_document('angelina','test',{:name=>"blah"})
    end
  end

  context "WHEN invoking GET https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "THEN it should retrieve the document" do
      res = @client.document('angelina','test','4e36c1535163dd2752000004')
    end
  end
  
  context "WHEN invoking PUT  https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "THEN it should retrieve the document" do
      res = @client.update_document('angelina','test','4e36c1535163dd2752000004', {:name=>'blah 1'})
    end
  end

  context "WHEN invoking DELETE https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "THEN it should delete the document" do
      res = @client.delete_document('angelina','test','4e36c1535163dd2752000004')
    end
  end
end