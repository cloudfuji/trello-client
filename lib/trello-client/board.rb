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
      # +board+:: Hash'ified JSON board
      #
      def initialize(board)
        @board = board
        yield self if block_given?
        self
      end

      #
      # Get Trello::Client::Board property
      #
      def[](key)
        @board[key]
      end

    end # class Board

  end # class Client
end   # module Trello

