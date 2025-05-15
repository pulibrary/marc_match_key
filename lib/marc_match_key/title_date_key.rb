# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the title date portion of a GoldRush key
  class TitleDateKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      f245 = record.fields('245').find { |f| f['f'] }
      return pad_with_underscores('', 15) if f245.nil?

      subff = clean_string(f245['f'])
      pad_with_underscores(subff, 15)
    end

    private

    def clean_string(string)
      string = normalize_string_and_remove_accents(string)
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
