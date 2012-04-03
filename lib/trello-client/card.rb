# encoding: utf-8

module Trello   # :nodoc:
  class Client  # :nodoc:

    #
    # Trello::Client::Card object
    #
    # See https://trello.com/docs/api/card/index.html
    #
    class Card

      #
      # Initialize Trello::Client::Card
      #
      # Params:
      # +card+:: Hash'ified JSON card or JSON string
      #
      def initialize(card)
        @card = card.kind_of?(Hash) ? card : MultiJson.decode(card)
        yield self if block_given?
        self
      end

      #
      # Get Trello::Client::Card property
      #
      def[](key)
        @card[key]
      end

      #
      # String representation.
      #
      def to_s
        @card.inspect
      end

    end # class Card

  end # class Client
end   # module Trello

