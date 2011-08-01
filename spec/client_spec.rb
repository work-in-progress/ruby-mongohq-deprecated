require 'spec_helper'
require 'mongohq'

describe Mongohq::Client do
  before(:each) do
    fake_it_all
    @client = Mongohq::Client.new("arthur","dent")
  end
  
  
  context "when invoking GET https://mongohq.com/api/databases" do
    it "should return a list of databases" do
      res = @client.databases
    end
  end

  context "when invoking POST https://mongohq.com/api/databases" do
    it "should create a new database" do
      res = @client.create_database('angelina','micro')
    end  
  end

  context "when invoking GET https://mongohq.com/api/databases/angelina" do
    it "should return details about the database" do
      res = @client.database('angelina')
    end
  end

  context "when invoking DELETE https://mongohq.com/api/databases/angelina" do
    it "should delete the database" do
      res = @client.delete_database('angelina')
      res['ok'].should == 1
    end
  end

  context "when invoking GET https://mongohq.com/api/databases/angelina/collections" do
    it "should return a list of collections" do
      res = @client.collections('angelina')
    end
  end

  context "when invoking POST https://mongohq.com/api/databases/angelina/collections" do
    it "should create a new collection" do
      res = @client.create_collection('angelina','test')
    end  
  end

  context "when invoking GET https://mongohq.com/api/databases/angelina/collections/test" do
    it "should return details about the collection" do
      res = @client.collection('angelina','test')
    end
  end
  
  context "when invoking PUT https://mongohq.com/api/databases/angelina/collections/test" do
    it "should rename the collection" do
      res = @client.rename_collection('angelina','test','test1')

    end
  end

  context "when invoking DELETE https://mongohq.com/api/databases/angelina/collections/test" do
    it "should delete the collection" do
      res = @client.delete_collection('angelina','test')
      res['ok'].should == 1
    end
  end
  
  context "when invoking GET https://mongohq.com/api/databases/angelina/collections/test/documents" do
    it "should return all documents in the collection" do
      res = @client.documents('angelina','test',{})
    end
  end

  context "when invoking POST https://mongohq.com/api/databases/angelina/collections/test/documents" do
    it "should create a new document" do
      res = @client.create_document('angelina','test',{:name=>"blah"})
    end
  end

  context "when invoking GET https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "should retrieve the document" do
      res = @client.document('angelina','test','4e36c1535163dd2752000004')
    end
  end
  
  context "when invoking PUT  https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "should retrieve the document" do
      res = @client.update_document('angelina','test','4e36c1535163dd2752000004', {:name=>'blah 1'})
    end
  end

  context "when invoking DELETE https://mongohq.com/api/databases/angelina/collections/test/documents/4e36c1535163dd2752000004" do
    it "should delete the document" do
      res = @client.delete_document('angelina','test','4e36c1535163dd2752000004')
    end
  end
end