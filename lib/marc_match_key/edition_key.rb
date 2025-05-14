# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the edition portion of a GoldRush key
  class EditionKey
    include MarcMatchFunctions
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    def generate_key
      f250 = record.fields('250').find { |f| f['a'] }
      return pad_with_underscores('1', 3) if f250.nil?

      subfa = clean_string(f250['a'])
      if subfa =~ /[0-9]/
        subfa.gsub!(/^[^0-9]*([0-9]+)[^0-9]*.*$/, '\1')
      else
        subfa.gsub!(/^[^a-z]*([a-z]+)[^0-9]*.*$/, '\1')
      end
      pad_with_underscores(subfa, 3)
    end

    def clean_string(string)
      string = normalize_string_and_remove_accents(string.dup)
      string.downcase!
      edition_string_to_numbers(string)
    end

    def edition_string_to_numbers(string)
      string.gsub!('fir', '1')
      string.gsub!('sec', '2')
      string.gsub!('thi', '3')
      string.gsub!('fou', '4')
      string.gsub!('fiv', '5')
      string.gsub!('six', '6')
      string.gsub!('sev', '7')
      string.gsub!('eig', '8')
      string.gsub!('nin', '9')
      string.gsub('ten', '10')
    end
  end
end
