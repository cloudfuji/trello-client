# encoding: utf-8

require 'simplecov'
SimpleCov.start

require 'fakeweb'
require 'trello-client'
require 'test/unit'


class TestMember < Test::Unit::TestCase

  def setup
    @test_dir   = File.dirname(__FILE__)
    @test_data  = File.join( @test_dir, 'data' )
  end

  def test_boards
    Trello::Client.new do |client|
      json  = open( File.join( @test_data, 'member_with_boards.json' ) ).read
      m     = Trello::Client::Member.new(json)

      assert_not_nil  m
      assert_kind_of  Trello::Client::Member, m

      assert_not_nil  m.boards
      assert_kind_of  Array,    m.boards
      assert_equal    3,        m.boards.size

      first = m.boards.first
      assert_not_nil  first
      assert_kind_of  Trello::Client::Board,                                                                first
      assert_equal    '4f4d0477e4ba0e4f09af1c6c',                                                           first['id']
      assert_equal    '5E - Survey Database Site Features',                                                 first['name']
      assert_equal    false,                                                                                first['closed']
      assert_nil      first['desc']
      assert_equal    '',                                                                                   first['idOrganization']
      assert_equal    true,                                                                                 first['pinned']
      assert_nil      first['url']
      assert_nil      first['prefs']

      last = m.boards.last
      assert_not_nil  last
      assert_kind_of  Trello::Client::Board,                                                                last
      assert_equal    '4f6c9a79c3974b4d730a5533',                                                           last['id']
      assert_equal    'uchicago',                                                                           last['name']
      assert_nil      last['desc']
      assert_equal    false,                                                                                last['closed']
      assert_equal    '',                                                                                   last['idOrganization']
      assert_equal    true,                                                                                 last['pinned']
      assert_nil      last['url']
      assert_nil      last['prefs']
    end
  end

end

