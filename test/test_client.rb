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

    FakeWeb.allow_net_connect = false
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

  def test_board_parameter_validation
    Trello::Client.new do |client|
      assert_raise(RuntimeError, 'invalid id') { client.board(nil) }
      assert_raise(RuntimeError, 'invalid id') { client.board('')  }

      assert_nil    client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.board('id') }
      client.api_key = ''
      assert_equal  '', client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.board('id') }
      client.api_key = @api_key
      assert_equal  @api_key, client.api_key  

      assert_nil    client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.board('id') }
      client.api_token = ''
      assert_equal  '', client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.board('id') }
    end
  end

  def test_board
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'board.json' ) ).read
      b     = Trello::Client::Board.new(json)
      client.stubs(:board).with('id').returns(b)

      assert_not_nil  b
      assert_kind_of  Trello::Client::Board,  b

      assert_equal    '4f4f9d55cf2e679318098c5b',                                         b['id']
      assert_equal    'Welcome Board',                                                    b['name']
      assert_equal    '',                                                                 b['desc']
      assert_equal    false,                                                              b['closed']
      assert_equal    true,                                                               b['pinned']
      assert_equal    'https://trello.com/board/welcome-board/4f4f9d55cf2e679318098c5b',  b['url']
      assert_not_nil  b['prefs']
      assert_kind_of  Hash,                                                               b['prefs']
      assert_equal    5,                                                                  b['prefs'].size

      assert_not_nil  b.lists
      assert_kind_of  Array,    b.lists
      assert_equal    0,        b.lists.size
    end
  end

  def test_board_with_lists
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'board_with_lists.json' ) ).read
      b     = Trello::Client::Board.new(json)
      client.stubs(:board).with('id').returns(b)

      assert_not_nil  b
      assert_kind_of  Trello::Client::Board,  b

      assert_equal    '4f4f9d55cf2e679318098c5b',                                         b['id']
      assert_equal    'Welcome Board',                                                    b['name']
      assert_equal    '',                                                                 b['desc']
      assert_equal    false,                                                              b['closed']
      assert_equal    true,                                                               b['pinned']
      assert_equal    'https://trello.com/board/welcome-board/4f4f9d55cf2e679318098c5b',  b['url']
      assert_not_nil  b['prefs']
      assert_kind_of  Hash,                                                               b['prefs']
      assert_equal    5,                                                                  b['prefs'].size

      assert_not_nil  b.lists
      assert_kind_of  Array,    b.lists
      assert_equal    3,        b.lists.size
    end
  end

  def test_card_parameter_validation
    Trello::Client.new do |client|
      assert_raise(RuntimeError, 'invalid id') { client.card(nil) }
      assert_raise(RuntimeError, 'invalid id') { client.card('')  }

      assert_nil    client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.card('id') }
      client.api_key = ''
      assert_equal  '', client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.card('id') }
      client.api_key = @api_key
      assert_equal  @api_key, client.api_key  

      assert_nil    client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.card('id') }
      client.api_token = ''
      assert_equal  '', client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.card('id') }
    end
  end

  def test_card
    Trello::Client.new do |client|
      client.api_key    = @api_key
      client.api_token  = @api_token

      json  = open( File.join( @test_data, 'card.json' ) ).read
      card  = Trello::Client::Card.new(json)
      uri   = "#{ client.api }/card/id?key=#{ client.api_key }&token=#{ client.api_token }"

      FakeWeb.register_uri( :get, uri, :body => json )

      blockable = false 
      card = client.card('id') do |card|
        assert_not_nil  card
        assert_kind_of  Trello::Client::Card,       card
        assert_equal    '4f4f9d56cf2e679318098ca3', card['id']
        assert_equal    false,                      card['closed']
        assert_equal    '',                         card['desc']
        assert_equal    'Welcome to Trello!',       card['name']

        blockable = true
      end

      assert_not_nil  card
      assert_kind_of  Trello::Client::Card,       card
      assert_equal    '4f4f9d56cf2e679318098ca3', card['id']
      assert_equal    false,                      card['closed']
      assert_equal    '',                         card['desc']
      assert_equal    'Welcome to Trello!',       card['name']
    end
  end

  def test_list_parameter_validation
    Trello::Client.new do |client|
      assert_raise(RuntimeError, 'invalid id') { client.list(nil) }
      assert_raise(RuntimeError, 'invalid id') { client.list('')  }

      assert_nil    client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.list('me') }
      client.api_key = ''
      assert_equal  '', client.api_key
      assert_raise(RuntimeError, 'invalid API key') { client.list('me') }
      client.api_key = @api_key
      assert_equal  @api_key, client.api_key  

      assert_nil    client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.list('me') }
      client.api_token = ''
      assert_equal  '', client.api_token
      assert_raise(RuntimeError, 'invalid API token') { client.list('me') }
    end
  end

  def test_list
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'list.json' ) ).read
      l     = Trello::Client::List.new(json)
      client.stubs(:list).with('id').returns(l)

      assert_not_nil  l
      assert_kind_of  Trello::Client::List, l

      assert_equal  '4f4f9d55cf2e679318098c53', l['id']
      assert_equal   'Basics',                  l['name']
      assert_equal  false,                      l['closed']
      assert_equal  '4f4f9d55cf2e679318098c5b', l['idBoard']
      assert_equal  16384,                      l['pos']

      assert_not_nil  l.cards
      assert_kind_of  Array,    l.cards
      assert_equal    0,        l.cards.size
    end
  end

  def test_list_with_boards
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'list_with_cards.json' ) ).read
      l     = Trello::Client::List.new(json)
      client.stubs(:list).with('id').returns(l)

      assert_not_nil  l
      assert_kind_of  Trello::Client::List, l

      assert_equal  '4f4f9d55cf2e679318098c53', l['id']
      assert_equal   'Basics',                  l['name']
      assert_equal  false,                      l['closed']
      assert_equal  '4f4f9d55cf2e679318098c5b', l['idBoard']
      assert_equal  16384,                      l['pos']

      assert_not_nil  l.cards
      assert_kind_of  Array,    l.cards
      assert_equal    6,        l.cards.size
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
      json  = open( File.join( @test_data, 'member.json' ) ).read
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
      json  = open( File.join( @test_data, 'member_with_boards.json' ) ).read
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

