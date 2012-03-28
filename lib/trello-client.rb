# encoding: utf-8

require 'multi_json'
require 'open-uri'
require 'uri'

require 'trello-client/member'
require 'trello-client/version'

#
# = Trello::Client - Trello API client
#
# == Configuration
#
# Get developer API key:
#   https://trello.com/1/appKey/generate
#
# Get user token:
#   https://trello.com/1/connect?key=$YOUR_API_KEY&name=trello-client.rb&response_type=token
#
# == Usage
#
#   require 'trello-client'
#
#   Trello::Client.new do |client|
#     # Set API key
#     client.api_key = ...
#
#     # Set token
#     client.token = ...
#
#     # Get member
#     client.member('blairchristensen') do |m|
#       # Returns Trello::Client::Member object
#       m['id']       # => member identity
#       m['fullName'] # => member name
#       m['userName'] # => member user
#
#       m.boards.each do |board|
#         # TODO Returns Board JSON
#     end 
#   end
#
# == Author
#
# blair christensen. <mailto:blair.christensen@gmail.com>
#
# == Homepage
#
# https://github.com/blairc/trello-client/
#
# == See Also
#
# * https://trello.com/docs/api/
#
# == To Do
#
# * Get boards
# * Get lists
# * Get cards
# * Memorize API calls
#
module Trello   # :nodoc:

  #
  # Trello API client.
  #
  class Client

    #
    # Get/Set Trello API URL
    #
    attr_accessor :api
 
    #
    # Get/Set Trello API key
    #
    attr_accessor :api_key
    
    #
    # Get/Set Trello API application token
    #
    attr_accessor :api_token

    #
    # Initialize Trello::Client object
    # 
    def initialize
      @api        = 'https://api.trello.com/1'
      @api_key    = nil
      @api_token  = nil
      yield self if block_given?
      self
    end

    #
    # Get Trello::Client::Member object
    # 
    # Params:
    # +id+:: Member identifier
    # +options+:: (optional) Additional API parameters
    #
    def member(id, options = {} )
      raise('invalid id') if id.nil? || id.empty?
      _get "#{api}/members/#{id}", options
    end


    private

    def _get( uri, options = {} )
      raise('invalid URI')        if uri.nil?         || uri.empty?
      raise('invalid API key')    if @api_key.nil?    || @api_key.empty?
      raise('invalid API token')  if @api_token.nil?  || @api_token.empty?

      defaults = { :key => @api_key, :token => @api_token }
      options.merge!(defaults)
      if options
        uri << '?'
        options.keys.sort.each do |k|
          uri << "#{k}=#{ options[k] }&"
        end
      end
      uri.gsub! /&$/, ''
      open(uri).read
    end

  end # class Client

end # module Trello

