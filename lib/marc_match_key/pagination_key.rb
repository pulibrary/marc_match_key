# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the publication date portion of a GoldRush key
  class PaginationKey
    include MarcMatchFunctions
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    ### follows GoldRush documentation, but the logic is not clear why
    ###   Date2 is preferred over Date1; monographs only have a date in Date1
    def generate_key
      f300 = record.fields('300').select { |f| f['a'] }.first
      return pad_with_underscores('', 4) if f300.nil?

      subfa = f300['a'].dup
      subfa.gsub!(/^[^0-9]*([0-9]{4}).*$/, '\1')
      subfa = '' if subfa =~ /[^0-9]/
      pad_with_underscores(subfa, 4)
    end
  end
end
