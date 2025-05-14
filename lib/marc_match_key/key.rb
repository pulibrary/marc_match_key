# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the Gov Doc portion of a GoldRush key
  class Key
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    def generate_key
      match_key = key_part_one
      match_key << key_part_two
      match_key << key_part_three
    end

    def key_part_one
      part = TitleKey.new(record).key
      part << PubDateKey.new(record).key
      part << PaginationKey.new(record).key
      part << EditionKey.new(record).key
    end

    def key_part_two
      part = PublisherKey.new(record).key
      part << TypeKey.new(record).key
      part << TitlePartKey.new(record).key
      part << TitleNumberKey.new(record).key
    end

    def key_part_three
      part = AuthorKey.new(record).key
      part << TitleDateKey.new(record).key
      part << GovDocKey.new(record).key
      part << FormatCharacterKey.new(record).key
    end
  end
end
