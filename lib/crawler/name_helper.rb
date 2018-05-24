module Crawler
  class NameHelper
    class << self
      VOWELS = %w(
        a e i o u
      ).freeze

      def proper(name)
        name.split(" ").map(&:capitalize).join(" ")
      end

      def definite(name)
        "the #{name.downcase}"
      end

      def indefinite(name)
        "#{choose_indefinite(name)} #{name.downcase}"
      end

      private

      def choose_indefinite(name)
        VOWELS.include?(name[0].downcase) ? "an" : "a"
      end
    end
  end
end
