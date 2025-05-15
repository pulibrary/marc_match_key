# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the publisher portion of a GoldRush key
  class PublisherKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      if publisher_26x_field.nil?
        pad_with_underscores('', 5)
      else
        subfb = publisher_26x_field['b'].to_s
        subfb = normalize_string_and_remove_accents(subfb)
        subfb = strip_punctuation(string: subfb)
        pad_with_underscores(subfb.downcase, 5)
      end
    end

    private

    def publisher_26x_field
      publisher_from_f264 || record.fields('260').find { |f| f['b'] }
    end

    def publisher_from_f264
      f264 = record.fields('264').select { |f| f['b'] }
      preferred_order = %w[1 4 2 3 0]
      preferred_order.each do |indicator|
        field = f264.find { |f| f.indicator2 == indicator }
        return field if field
      end
      nil
    end
  end
end
