# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the format character portion of a GoldRush key
  class FormatCharacterKey
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      if (record['245'] && record['245']['h'] =~ /electronic resource/) ||
         electronic_resource_3xx? ||
         electronic_resource_5xx_f007? ||
         (record['086'] && record['856'])
        'e'
      else
        'p'
      end
    end

    private

    def electronic_resource_5xx_f007?
      record.fields(%w[533 590]).any? { |f| f['a'] =~ /[Ee]lectronic reproduction/ } ||
        record.fields('007').any? { |f| f.value[0].downcase == 'c' }
    end

    def electronic_resource_3xx?
      record.fields('300').any? { |f| f['a'] =~ /[Oo]nline resource/ } ||
        record.fields('337').any? { |f| f['a'] =~ /^c/ }
    end
  end
end
