# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the edition portion of a GoldRush key
  class EditionKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      f250 = record.fields('250').find { |f| f['a'] }
      return pad_with_underscores('1', 3) if f250.nil?

      subfa = clean_string(f250['a'])
      normalized = if subfa =~ /[0-9]/
                     subfa.gsub(/^[^0-9]*([0-9]+)[^0-9]*.*$/, '\1')
                   else
                     subfa.gsub(/^[^a-z]*([a-z]+)[^0-9]*.*$/, '\1')
                   end
      pad_with_underscores(normalized, 3)
    end

    private

    def clean_string(string)
      string = normalize_string_and_remove_accents(string)
      edition_string_to_numbers(string.downcase)
    end

    def edition_string_to_numbers(string)
      string.gsub('fir', '1')
            .gsub('sec', '2')
            .gsub('thi', '3')
            .gsub('fou', '4')
            .gsub('fiv', '5')
            .gsub('six', '6')
            .gsub('sev', '7')
            .gsub('eig', '8')
            .gsub('nin', '9')
            .gsub('ten', '10')
    end
  end
end
