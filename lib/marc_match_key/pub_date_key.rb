# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the publication date portion of a GoldRush key
  class PubDateKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    ### follows GoldRush documentation, but the logic is not clear why
    ###   Date2 is preferred over Date1; monographs only have a date in Date1
    def key
      pub_date = pub_date_from_f008
      pub_date ||= pub_date_from_pub_field(pub_date_26x_field)
      pad_with_underscores(pub_date, 4)
    end

    private

    def pub_date_from_f008
      f008 = record['008']&.value
      if f008 && f008[6] == 'r'
        pub_date = f008[7..10]
      elsif f008
        pub_date = f008[11..14]
      end
      pub_date = nil if pub_date =~ /[^0-9]/
      pub_date
    end

    ### GoldRush uses the first 264 field to appear in the record, which could
    ###   end up using the copyright date or another type of date instead of
    ###   publication date
    def pub_date_26x_field
      pub_date_from_f264 || record.fields('260').find { |f| f['c'] }
    end

    def pub_date_from_f264
      preferred_order = %w[1 4 2 3 0]
      f264 = record.fields('264').select { |f| f['c'] }
      preferred_order.each do |indicator|
        field = f264.find { |f| f.indicator2 == indicator }
        return field if field
      end
      nil
    end

    def pub_date_from_pub_field(pub_field)
      return '0000' if pub_field.nil?

      pub_date = pub_field['c'].gsub(/^.*([0-9]{4})[^0-9]*$/, '\1')
      pub_date = '0000' if pub_date !~ /^[0-9]{4}$/
      pub_date
    end
  end
end
