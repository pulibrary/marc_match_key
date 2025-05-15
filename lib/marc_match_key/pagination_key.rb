# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the pagination portion of a GoldRush key
  class PaginationKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      f300 = record.fields('300').find { |f| f['a'] }
      return pad_with_underscores('', 4) if f300.nil?

      subfa = f300['a'].gsub(/^[^0-9]*([0-9]{4}).*$/, '\1')
      subfa = '' if subfa =~ /[^0-9]/
      pad_with_underscores(subfa, 4)
    end
  end
end
