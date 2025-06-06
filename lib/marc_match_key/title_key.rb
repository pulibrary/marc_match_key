# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the title portion of a GoldRush key
  class TitleKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      field = record['245']
      return pad_with_underscores('', 70) if field.nil?

      title_key = nil
      subf6 = field['6'].dup
      if subf6
        field_num = subf6.gsub(/^880-(.*)$/, '\1')
        field_num.gsub!(/[^0-9].*$/, '')
        title_key = title_key_from880(record, field_num)
      end
      title_key || process_title_field(field)
    end

    private

    def title_key_from880(record, field_num)
      return if field_num == ''

      f880 = record.fields('880').find { |f| f['6'] =~ /^245-#{field_num}/ }
      return if f880.nil?

      process_title_field(f880)
    end

    def process_title_field(field)
      key = ''.dup
      field.subfields.each do |subfield|
        next unless %w[a b p].include?(subfield.code)

        substring = strip_punctuation(string: subfield.value)
        substring = normalize_string_and_remove_accents(substring)
        key << substring.downcase
      end
      pad_with_underscores(key.strip, 70)
    end
  end
end
