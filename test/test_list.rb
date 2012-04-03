# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'fakeweb'
require 'trello-client'
require 'test/unit'


class TestList < Test::Unit::TestCase

  def setup
    @test_dir   = File.dirname(__FILE__)
    @test_data  = File.join( @test_dir, 'data' )
  end

  def test_to_s
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'list.json' ) ).read
      list  = Trello::Client::List.new(json)
      assert_equal  MultiJson.decode(json).to_s, list.to_s
    end
  end

  def test_cards
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'list_with_cards.json' ) ).read
      l     = Trello::Client::List.new(json)

      assert_not_nil  l
      assert_kind_of  Trello::Client::List, l

      assert_not_nil  l.cards
      assert_kind_of  Array,    l.cards
      assert_equal    6,        l.cards.size

      first = l.cards.first
      assert_not_nil  first
      assert_kind_of  Trello::Client::Card,                                                   first
      assert_equal    [],                                                                     first['attachments'] 
      assert_kind_of  Hash,                                                                   first['badges']
      assert_equal    [],                                                                     first['checkItemStates'] 
      assert_equal    false,                                                                  first['closed']
      assert_equal    '',                                                                     first['desc']
      assert_equal    '4f4f9d56cf2e679318098ca3',                                             first['id']
      assert_equal    '4f4f9d55cf2e679318098c5b',                                             first['idBoard']
      assert_equal    [],                                                                     first['idChecklists'] 
      assert_equal    '4f4f9d55cf2e679318098c53',                                             first['idList']
      assert_equal    [],                                                                     first['idMembers']
      assert_equal    1,                                                                      first['idShort']
      assert_equal    [],                                                                     first['labels'] 
      assert_equal    'Welcome to Trello!',                                                   first['name']
      assert_equal    65536,                                                                  first['pos']
      assert_equal    'https://trello.com/card/welcome-to-trello/4f4f9d55cf2e679318098c5b/1', first['url']

      last = l.cards.last
      assert_not_nil  last
      assert_kind_of  Trello::Client::Card,                                               last
      assert_equal    [],                                                                 last['attachments'] 
      assert_kind_of  Hash,                                                               last['badges']
      assert_kind_of  Array,                                                              last['checkItemStates']
      assert_equal    false,                                                              last['closed']
      assert_equal    '',                                                                 last['desc']
      assert_equal    '4f4f9d56cf2e679318098cb1',                                         last['id']
      assert_equal    '4f4f9d55cf2e679318098c5b',                                         last['idBoard']
      assert_equal    [ '4f4f9d55cf2e679318098c59' ],                                     last['idChecklists'] 
      assert_equal    '4f4f9d55cf2e679318098c53',                                         last['idList']
      assert_equal    [],                                                                 last['idMembers']
      assert_equal    6,                                                                  last['idShort']
      assert_equal    [],                                                                 last['labels'] 
      assert_equal    '... or checklists.',                                               last['name']
      assert_equal    393216,                                                             last['pos']
      assert_equal    'https://trello.com/card/or-checklists/4f4f9d55cf2e679318098c5b/6', last['url']
    end
  end

end

