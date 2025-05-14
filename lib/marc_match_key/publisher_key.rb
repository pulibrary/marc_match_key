# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the publication date portion of a GoldRush key
  class PublisherKey
    include MarcMatchFunctions
    attr_reader :record, :key

    def initialize(record)
      @record = record
      @key ||= generate_key
    end

    private

    ### follows GoldRush documentation, but the logic is not clear why
    ###   Date2 is preferred over Date1; monographs only have a date in Date1
    def generate_key
      pub_field = publisher_26x_field
      publisher_from_pub_field(pub_field)
    end

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

    def publisher_from_pub_field(pub_field)
      return pad_with_underscores('', 5) if pub_field.nil?

      subfb = pub_field['b'].dup.to_s
      subfb = normalize_string_and_remove_accents(subfb)
      subfb = strip_punctuation(string: subfb)
      subfb.downcase!
      pad_with_underscores(subfb, 5)
    end
  end
end
