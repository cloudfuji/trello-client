# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'fakeweb'
require 'mocha'
require 'trello-client'
require 'test/unit'


class TestClient < Test::Unit::TestCase

  def setup
    @api_key    = 'test'
    @api_token  = 'test'

    @test_dir   = File.dirname(__FILE__)
    @test_data  = File.join( @test_dir, 'data' )
  end


  def test_initialization
     blockable = false
     client = Trello::Client.new do |client|
       assert_kind_of  Trello::Client, client
       blockable = true
     end
     assert         blockable,          'works as block'
     assert_kind_of Trello::Client, client
     assert_kind_of Trello::Client, Trello::Client.new
   end

  def test_accessors
    Trello::Client.new do |client|
      assert_equal  'https://api.trello.com/1', client.api
      assert_nil    client.api_key
      assert_nil    client.api_token
    end
  end

  def test_member_parameter_validation
    Trello::Client.new do |client|
      assert_raise(RuntimeError, 'invalid id') { client.member(nil) }
      assert_raise(RuntimeError, 'invalid id') { client.member('')  }

      assert_nil    client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.member('me') }
      client.api_key = ''
      assert_equal  '', client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.member('me') }
      client.api_key = @api_key
      assert_equal  @api_key, client.api_key  

      assert_nil    client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.member('me') }
      client.api_token = ''
      assert_equal  '', client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.member('me') }
    end
  end

  def test_member
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'member.json' ) )
      m     = Trello::Client::Member.new(json)
      client.stubs(:member).with('me').returns(m)

      assert_not_nil  m
      assert_kind_of  Trello::Client::Member, m

      assert_equal  '65fcb89a59ff96b68b11332686c8f4f9',     m['avatarHash']
      assert_equal  '',                                     m['bio']
      assert_nil    m['boards']
      assert_equal  'blair christensen',                    m['fullName']
      assert_equal  '4f4f9d55cf2e679318098c45',             m['id']
      assert_equal  'BC',                                   m['initials']
      assert_equal  'https://trello.com/blairchristensen',  m['url']
      assert_equal  'blairchristensen',                     m['username']

      assert_not_nil  m.boards
      assert_kind_of  Array,    m.boards
      assert_equal    0,        m.boards.size
    end
  end

  def test_member_with_boards
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'member_with_boards.json' ) )
      m     = Trello::Client::Member.new(json)
      client.stubs(:member).with('me').returns(m)

      assert_not_nil  m
      assert_kind_of  Trello::Client::Member, m

      assert_equal    '65fcb89a59ff96b68b11332686c8f4f9',     m['avatarHash']
      assert_equal    '',                                     m['bio']
      assert_not_nil  m['boards']
      assert_equal    'blair christensen',                    m['fullName']
      assert_equal    '4f4f9d55cf2e679318098c45',             m['id']
      assert_equal    'BC',                                   m['initials']
      assert_equal    'https://trello.com/blairchristensen',  m['url']
      assert_equal    'blairchristensen',                     m['username']

      assert_not_nil  m.boards
      assert_kind_of  Array,    m.boards
      assert_equal    3,        m.boards.size
    end
  end

  def test_underscore_get_parameter_validation
    Trello::Client.new do |client|
      uri = "#{ client.api }/member/me"

      assert_raise(RuntimeError, 'invalid URI') { client.send( :_get, nil ) }
      assert_raise(RuntimeError, 'invalid URI') { client.send( :_get, '' )  }

      assert_raise(RuntimeError, 'invalid API key') { client.send( :_get, uri ) }
      assert_raise(RuntimeError, 'invalid API key') { client.send( :_get, uri ) }
      client.api_key = @api_key

      assert_raise(RuntimeError, 'invalid API token') { client.send( :_get, uri ) }
      assert_raise(RuntimeError, 'invalid API token') { client.send( :_get, uri ) }
      client.api_token = @api_token
    end
  end

  def test_underscore_get
    Trello::Client.new do |client|
      json      = open( File.join( @test_data, 'member.json' ) ).read
      uri       = "#{ client.api }/member/me"
      fake_uri  = "#{uri}?key=test&token=test"
      FakeWeb.register_uri( :get, fake_uri, :body => json )

      client.api_key    = @api_key
      client.api_token  = @api_token

      r = client.send( :_get, uri )
      
      assert_not_nil  r
      assert_equal    json, r
    end

  end

end

