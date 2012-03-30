# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'fakeweb'
require 'trello-client'
require 'test/unit'


class TestBoard < Test::Unit::TestCase

  def setup
    @test_dir   = File.dirname(__FILE__)
    @test_data  = File.join( @test_dir, 'data' )
  end

  def test_lists
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'board_with_lists.json' ) ).read
      b     = Trello::Client::Board.new(json)

      assert_not_nil  b
      assert_kind_of  Trello::Client::Board, b

      assert_not_nil  b.lists
      assert_kind_of  Array,    b.lists
      assert_equal    3,        b.lists.size

      first = b.lists.first
      assert_not_nil  first
      assert_kind_of  Trello::Client::List,       first
      assert_equal    false,                      first['closed']
      assert_equal    '4f4f9d55cf2e679318098c53', first['id']
      assert_equal    '4f4f9d55cf2e679318098c5b', first['idBoard']
      assert_equal    16384,                      first['pos']
      assert_equal    'Basics',                   first['name']

      assert_not_nil  first.cards
      assert_kind_of  Array,      first.cards
      assert_equal    0,          first.cards.size

      last = b.lists.last
      assert_not_nil  last
      assert_kind_of  Trello::Client::List,       last
      assert_equal    false,                      last['closed']
      assert_equal    '4f4f9d55cf2e679318098c55', last['id']
      assert_equal    '4f4f9d55cf2e679318098c5b', last['idBoard']
      assert_equal    49152,                      last['pos']
      assert_equal    'Advanced',                 last['name']

      assert_not_nil  last.cards
      assert_kind_of  Array,      last.cards
      assert_equal    0,          last.cards.size
    end
  end

end

