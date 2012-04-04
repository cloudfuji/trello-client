# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'fakeweb'
require 'trello-client'
require 'test/unit'


class TestCard < Test::Unit::TestCase

  def setup
    @test_dir   = File.dirname(__FILE__)
    @test_data  = File.join( @test_dir, 'data' )
  end

  def test_to_s
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'card.json' ) ).read
      board = Trello::Client::Card.new(json)
      assert_equal  MultiJson.decode(json).to_s, board.to_s
    end
  end

end

