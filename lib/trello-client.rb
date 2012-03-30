# encoding: utf-8

require 'multi_json'
require 'open-uri'
require 'uri'

require 'trello-client/board'
require 'trello-client/list'
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
#     client.member('me') do |m|
#       # Returns Trello::Client::Member object
#       m['id']       # => member identifier
#       m['fullName'] # => member name
#       m['userName'] # => member user
#       m['url']      # => member url
#     end
#
#     # Get member with boards
#     client.member( 'me', :boards => 'all' ) do |m|
#       m.boards.each do |b|
#         # Returns Trello::Client::Board objects
#         b['id']     # => board identifier
#         b['name']   # => board name
#     end 
#
#     # Get board
#     client.board( '<identifier>' ) do |b|
#       # Returns Trello::Client::Board object
#       b['id']     # => board identifier
#       b['name']   # => board name
#       b['url']    # => board url
#     end
#
#     # Get board with lists
#     client.board( '<identifier>', :lists => 'all' ) do |b|
#       # Returns Trello::Client::Board object
#       b.lists.each do |l|
#         # Returns Trello::Client::List object
#         l['id']       # => list identifier
#         l['idBoard']  # => list board identifier
#         l['name']     # => list name
#       end
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
# * Trello::Client#list()
# * Get cards
# * Memoize API calls
# * Add script
# * DRY +Board+, +List+ and +Member+
# * Lazy fetching of data that wasn't requested?
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
    # Get Trello::Client::Board object
    # 
    # See https://trello.com/docs/api/board/index.html
    #
    # Params:
    # +id+:: Board identifier
    # +options+:: (optional) Additional API parameters
    #
    def board(id, options = {} )
      raise('invalid id') if id.nil? || id.empty?
      Trello::Client::Board.new( _get( "#{api}/board/#{id}", options ) )
    end

    #
    # Get Trello::Client::Member object
    # 
    # See https://trello.com/docs/api/member/index.html
    #
    # Params:
    # +id+:: Member identifier
    # +options+:: (optional) Additional API parameters
    #
    def member(id, options = {} )
      raise('invalid id') if id.nil? || id.empty?
      Trello::Client::Member.new( _get( "#{api}/members/#{id}", options ) )
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

