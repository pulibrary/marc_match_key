# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the title number portion of a GoldRush key
  ### Unclear from the documentation how it handles multiple 245$n
  class TitleNumberKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      f245 = record.fields('245').find { |f| f['n'] }
      return pad_with_underscores('', 10) if f245.nil?

      title_number_key = f245.subfields.select { |subfield| subfield.code == 'n' }
                             .map { |subfield| clean_string(subfield.value) }
                             .join
      pad_with_underscores(title_number_key, 10)
    end

    private

    def clean_string(string)
      string = normalize_string_and_remove_accents(string)
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
