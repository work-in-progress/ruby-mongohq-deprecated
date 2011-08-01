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
  #   
  class Client
    include HTTParty
    base_uri 'https://mongohq.com/api'

    # Inititalizer for the client class. 
    # @param [String] api_key the api_key name of your mongohq.com account.
    # @param [String] api_secret the api_secret of your mongohq.com account.
    # @return [Client] a new instance of the client.
    def initialize(api_key, api_secret )
      @auth = {:api_key => api_key, :api_secret => api_secret}
    end
          
private
    # Examines a bad response and raises an appropriate exception
    #
    # @param [HTTParty::Response] the response as returned by the web request.
    # @raise [ResponseError] raised in case of a web service related error.
    # @raise [StandardError] raised in case of an error that is not web service related. 
    # @return [HTTParty::Response] the response as returned by the web request.
    def self.bad_response(response)
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
      response.ok? ? response : bad_response(response) 
    end

public  

    # Returns a list of all databases.
    # @return [HTTParty::Response] A response.
    #   An array containing a list of databases.
    #   ["scottyapp","shopsnearme","taglist","triponadeal"]  
    def databases()
      options={:basic_auth => @auth}
      handle_result self.class.get('/databases', options)
    end



=begin  
    # Updates the settings for the current user.
    # @option opts [String] :password the password to update.
    # @option opts [String] :rsakey the rsa key to update.
    # @return [HTTParty::Response] A response.
    def update_user(opts={})
      options={:body => opts,:basic_auth => @auth}
      handle_result self.class.put('/user', options)
    end

    # Deletes the current user.
    # @return [HTTParty::Response] A response.
    def platform_delete_user()
      options={:basic_auth => @auth}
      handle_result self.class.delete('/user', options)
    end
  


    # Creates a new app.
    # @param (String) appname the name of the app.
    # @param (String) start the file that contains the node.js startup code. (server.js)
    # @return [HTTParty::Response] A response.
    # @note The result contains the following entries (check http://mongohq.com for up to date information):
    #   * 'status' : "success" | "failure"
    #   * 'message' : "some text" ==> Only if failure
    #   * 'port' : 12345
    #   * 'gitrepo' : 'git@mongohq.com:/node/git/mwawrusch/blah.git'
    #   * 'start' : "the value of start, for example servre.js"
    #   * 'running' : true | false 
    #   * 'pid' : "unknown" | some pid 
    def create_app(appname,start)
      options={:body => {:appname=>appname,:start=>start}, :basic_auth => @auth}
      handle_result self.class.post('/app', options)
    end

    # Updates properties of an app.
    # @param (String) appname the name of the app.
    # @option opts [String] :start the startup file that contains the node.js startup code.
    # @return [HTTParty::Response] A response.
    def update_app(appname,opts = {})
      opts.merge!({:appname => appname})
      
      options={:body=> opts, :basic_auth => @auth}
      handle_result self.class.put('/app', options)
    end
    
    # Starts or stops an app.
    # @param (String) appname the name of the app.
    # @param (Boolean) running true to start the app; false to stop the app.
    # @return [HTTParty::Response] A response.
    def start_stop_app(appname,running = true)
      
      options={:body=> {:appname => appname, :running=>start}, :basic_auth => @auth}
      handle_result self.class.put('/app', options)
    end

    # Deletes an app.
    # @param (String) appname the name of the app.
    # @return [HTTParty::Response] A response.
    def delete_app(appname)
      options={:body => {:appname => appname}, :basic_auth => @auth}
      handle_result self.class.delete('/app', options)
    end
  
    # Returns the properties of an app.
    # @param (String) appname the name of the app.
    # @return [HTTParty::Response] A response.
    def app(appname)
      options={:body => {},:basic_auth => @auth}
      handle_result self.class.get("/app/#{appname}", options)
    end
  

  
  
    # Creates or updates a value for a key in the app's environment.
    # @param (String) appname the name of the app.
    # @param (String) key the key (name) of the evironment variable.
    # @param (String) value the value of the environment variable.
    # @return [HTTParty::Response] A response.
    def update_env(appname,key,value)
      options={:body => {:appname => appname,:key=>key,:value=>value},:basic_auth => @auth}
      handle_result self.class.put('/env', options)
    end

    # Deletes a key from the app's environment.
    # @param (String) appname the name of the app.
    # @param (String) key the key (name) of the evironment variable.
    # @return [HTTParty::Response] A response.
    def delete_env(appname,key)
      options={:body => {:appname => appname,:key=>key},:basic_auth => @auth}
      handle_result self.class.delete('/env', options)
    end
  
    # Returns the value of a key in the app's environment.
    # @param (String) appname the name of the app.
    # @param (String) key the key (name) of the evironment variable.
    # @return [HTTParty::Response] A response.
    def env(appname,key)
      options={:body => {:appname => appname,:key=>key},:basic_auth => @auth}
      handle_result self.class.get('/env', options)
    end
  
  
    # Manages the NPM package manager associated with an app.
    # @param (String) appname the name of the app.
    # @param (String) action the action to perform. Can be install|upgrade|uninstall. Check official documentation
    #  for more info.
    # @param (String) package the name of the package that should be worked with.
    # @return [HTTParty::Response] A response.
    def update_npm(appname,action,package)
      options={:body => {:appname => appname,:action => action,:package=>package},:basic_auth => @auth}
      handle_result self.class.post('/npm', options)
    end
  
    # Creates a new domain entry for an app.
    # @note Check out the http://notester.com site for up to date information how to set your
    #   a record to route the domain to the actual servers.
    # @param (String) appname the name of the app.
    # @param (String) domain the domain to be associated with the app.
    # @return [HTTParty::Response] A response.
    def create_appdomain(appname,domain)
      options={:body => {:appname => appname,:domain=>domain},:basic_auth => @auth}
      handle_result self.class.post('/appdomains', options)
    end
  
    # Deletes a domain entry from an app.
    # @param (String) appname the name of the app.
    # @param (String) domain the domain to be disassociated from the app.
    # @return [HTTParty::Response] A response.
    def delete_appdomain(appname,domain)
      options={:body => {:appname => appname,:domain=>domain},:basic_auth => @auth}
      handle_result self.class.delete('/appdomains', options)
    end
  
    # Returns a list of all app domains for all apps of the current user.
    # @return [HTTParty::Response] A response.
    def appdomains()
      options={:basic_auth => @auth}
      handle_result self.class.get('/appdomains', options)
    end
=end

  end
end

