# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the author portion of a GoldRush key
  ### GoldRush includes the 130 field, even though that is not an author
  ### Goldrush documentation says the key is padded to 5 characters, but it
  ###   also says that it's padded to 20 characters
  class AuthorKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      auth_fields = record.fields.select do |field|
        %w[100 110 111 113 130].include?(field.tag) &&
          field['a']
      end
      author_key = auth_fields.map { |field| clean_string(field['a']) }.join
      pad_with_underscores(author_key, 20)
    end

    private

    def clean_string(string)
      string = normalize_string_and_remove_accents(string)
      string = strip_punctuation(string: string)
      string.downcase
    end
  end
end
