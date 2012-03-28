# encoding: utf-8

module Trello   # :nodoc:
  class Client  # :nodoc

    #
    # Trello::Client::Member object
    #
    class Member

      #
      # Initialize Trello::Member
      #
      def initialize(json)
        @json = MultiJson.decode(json)
        yield self if block_given?
        self
      end

      #
      # Get Trello::Member property
      #
      def[](key)
        @json[key]
      end

      #
      # Get +Array+ of boards
      #
      def boards
        @json['boards'] || []
      end

    end # class Member

  end # class Client
end   # module Trello

