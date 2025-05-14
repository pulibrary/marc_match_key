# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the title part portion of a GoldRush key
  class TitlePartKey
    include MarcMatchFunctions
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    def generate_key
      f245 = record.fields('245').find { |f| f['p'] }
      return pad_with_underscores('', 30) if f245.nil?

      title_part_key = ''.dup
      f245.subfields.each do |subfield|
        next unless subfield.code == 'p'

        part = clean_string(subfield.value)
        title_part_key << part[0..9]
      end
      pad_with_underscores(title_part_key, 30)
    end

    def clean_string(string)
      string = normalize_string_and_remove_accents(string.dup)
      string.strip!
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
