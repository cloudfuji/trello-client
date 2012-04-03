# encoding: utf-8

module Trello   # :nodoc:
  class Client  # :nodoc:

    #
    # Trello::Client::Board object
    #
    # See https://trello.com/docs/api/board/index.html
    #
    class Board

      #
      # Initialize Trello::Client::Board
      #
      # Params:
      # +board+:: Hash'ified JSON board or JSON string
      #
      def initialize(board)
        @board = board.kind_of?(Hash) ? board : MultiJson.decode(board)
        yield self if block_given?
        self
      end

      #
      # Get Trello::Client::Board property
      #
      def[](key)
        @board[key]
      end

      #
      # Get +Array+ of Trello::Client::List objects
      #
      def lists
        unless @lists
          @lists = ( @board['lists'] || []  ).collect { |l| Trello::Client::List.new(l) }
        end
        @lists
      end

      #
      # String representation.
      #
      def to_s
        @board.to_s
      end

    end # class Board

  end # class Client
end   # module Trello

