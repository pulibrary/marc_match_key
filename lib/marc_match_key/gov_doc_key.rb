# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the Gov Doc portion of a GoldRush key
  class GovDocKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      f086 = record.fields('086').find { |f| f['a'] }
      return '' if f086.nil?

      subfa = clean_string(f086['a'])
      trim_max_field_length(subfa)
    end

    private

    def clean_string(string)
      string = normalize_string_and_remove_accents(string)
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
