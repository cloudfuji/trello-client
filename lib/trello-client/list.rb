# encoding: utf-8

module Trello   # :nodoc:
  class Client  # :nodoc:

    #
    # Trello::Client::List object
    #
    # See https://trello.com/docs/api/list/index.html
    #
    class List

      #
      # Initialize Trello::Client::List
      #
      # Params:
      # +list+:: Hash'ified JSON list or JSON string
      #
      def initialize(list)
        @list = list.kind_of?(Hash) ? list : MultiJson.decode(list)
        yield self if block_given?
        self
      end

      #
      # Get Trello::Client::List property
      #
      def[](key)
        @list[key]
      end

      #
      # Get +Array+ of Trello::Client::Card objects
      #
      def cards
        unless @lists
          @cards = ( @list['cards'] || []  ).collect { |c| Trello::Client::Card.new(c) }
        end
        @cards
      end

      #
      # String representation.
      #
      def to_s
        @list.inspect
      end

    end # class List

  end # class Client
end   # module Trello

