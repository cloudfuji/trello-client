#!/usr/bin/env ruby

#
# TODO Extract to Trello::Client::???
# TODO More configurable
#

require 'trello-client'

USAGE = "USAGE: #{ File.basename(__FILE__) } [-h] <board name>"

name = ARGV.shift
unless name
  warn USAGE
  exit(1)
end
if %w( -h -help --help help ).include?(name)
  puts USAGE
  exit
end


Trello::Client.new do |client|
  client.api_key    = ENV['TRELLO_API_KEY']
  client.api_token  = ENV['TRELLO_API_TOKEN']

  client.member( 'me', :boards => 'all' ) do |member|
    board = member.boards.find { |b| name == b['name'] }
    unless board
      warn "ERROR: board '#{name}' not found"
      exit(1)
    end
    client.board( board['id'], :lists => 'all' ).lists.each do |list|
      puts "#{ list['name'] }\n#{ '~' * list['name'].length }"
      client.list( list['id'], :cards => 'open' ).cards.each do |card|
        puts "- #{ card['name'] }"
      end
      1.upto(2) { puts }
    end
  end

end

