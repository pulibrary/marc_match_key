# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates GoldRush key
  class Key
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      [key_part_one, key_part_two, key_part_three].join
    end

    private

    def key_part_one
      [TitleKey, PubDateKey, PaginationKey, EditionKey]
        .map { |key_type| key_type.new(record).key }
        .join
    end

    def key_part_two
      [PublisherKey, TypeKey, TitlePartKey, TitleNumberKey]
        .map { |key_type| key_type.new(record).key }
        .join
    end

    def key_part_three
      [AuthorKey, TitleDateKey, GovDocKey, FormatCharacterKey]
        .map { |key_type| key_type.new(record).key }
        .join
    end
  end
end
