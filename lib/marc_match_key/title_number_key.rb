# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the title number portion of a GoldRush key
  ### Unclear from the documentation how it handles multiple 245$n
  class TitleNumberKey
    include MarcMatchFunctions
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    def generate_key
      f245 = record.fields('245').find { |f| f['n'] }
      return pad_with_underscores('', 10) if f245.nil?

      title_number_key = ''.dup
      f245.subfields.each do |subfield|
        next unless subfield.code == 'n'

        part = clean_string(subfield.value)
        title_number_key << part
      end
      pad_with_underscores(title_number_key, 10)
    end

    def clean_string(string)
      string = normalize_string_and_remove_accents(string.dup)
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
