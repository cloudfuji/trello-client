# encoding: utf-8

require 'multi_json'
require 'open-uri'
require 'uri'

require 'trello-client/board'
require 'trello-client/card'
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
#       b.lists.each do |l|
#         # Returns Trello::Client::List object
#         l['id']       # => list identifier
#         l['idBoard']  # => list board identifier
#         l['name']     # => list name
#       end
#     end
#
#     # Get list
#     client.list( '<identifier>' ) do |l|
#       # Returns Trello::Client::List object
#       l['id']       # => list identifier
#       l['idBoard']  # => list board identifier
#       l['name']     # => list name
#     end
#
#     # Get list with cards
#     client.list( '<identifier>' ) do |l|
#       l.cards.each do |c|
#         # Returns Trello::Client::Card object
#         c['id']       # => card identifier
#         c['idBoard']  # => card board identifier
#         c['idList']   # => card list identifier
#         c['name']     # => card name
#       end
#     end
#
#     # Get card
#     client.card( '<identifier>' ) do |card|
#       card['id']      # => card identifier
#       card['name']    # => card name
#       card['closed']  # => true | false
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
# * DRY +Card+, +Board+, +List+ and +Member+
# * DRY +board()+, +list()+ and +member()+
# * Make +trello2todo+ configurable
# * Actual API test that can be run on demand
# * Memoize API calls
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
      board = Trello::Client::Board.new( _get( "#{api}/board/#{id}", options ) )
      yield board if block_given?
      board
    end

    #
    # Get Trello::Client::Card object
    # 
    # See https://trello.com/docs/api/card/index.html
    #
    # Params:
    # +id+:: Card identifier
    # +options+:: (optional) Additional API parameters
    #
    def card(id, options = {} )
      raise('invalid id') if id.nil? || id.empty?
      card = Trello::Client::Card.new( _get( "#{api}/card/#{id}", options ) )
      yield card if block_given?
      card
    end

    #
    # Get Trello::Client::List object
    # 
    # See https://trello.com/docs/api/list/index.html
    #
    # Params:
    # +id+:: List identifier
    # +options+:: (optional) Additional API parameters
    #
    def list(id, options = {} )
      raise('invalid id') if id.nil? || id.empty?
      l = Trello::Client::List.new( _get( "#{api}/list/#{id}", options ) )
      yield l if block_given?
      l
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
      m = Trello::Client::Member.new( _get( "#{api}/members/#{id}", options ) )
      yield m if block_given?
      m
    end


    private

    def _get( uri, options = {} )
      _validate_request!(uri)

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

    def _validate_request!(uri)
      raise('invalid URI')        if uri.nil?         || uri.empty?
      raise('invalid API key')    if @api_key.nil?    || @api_key.empty?
      raise('invalid API token')  if @api_token.nil?  || @api_token.empty?
    end

  end # class Client

end # module Trello

