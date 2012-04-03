# encoding: utf-8

module Trello   # :nodoc:
  class Client  # :nodoc:

    #
    # Trello::Client::Member object
    #
    # See https://trello.com/docs/api/member/index.html
    #
    class Member

      #
      # Initialize Trello::Client::Member
      #
      # Params:
      # +member+:: JSON member
      #
      def initialize(member)
        @member = MultiJson.decode(member)
        yield self if block_given?
        self
      end

      #
      # Get Trello::Client::Member property
      #
      def[](key)
        @member[key]
      end

      #
      # Get +Array+ of Trello::Client::Board objects
      #
      def boards
        unless @boards
          @boards = ( @member['boards'] || []  ).collect { |b| Trello::Client::Board.new(b) }
        end
        @boards
      end

      #
      # String representation.
      #
      def to_s
        @member.to_s
      end

    end # class Member

  end # class Client
end   # module Trello

