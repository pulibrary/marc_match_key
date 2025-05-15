# frozen_string_literal: true

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  ### Generates the type portion of a GoldRush key
  class TypeKey
    include MarcMatchFunctions
    attr_reader :record

    def initialize(record)
      @record = record
    end

    def key
      leader_val = record.leader.dup
      leader_val.force_encoding('utf-8')
      return pad_with_underscores('', 1) unless leader_val&.size&.> 9

      type_char = normalize_string_and_remove_accents(leader_val[6])
      pad_with_underscores(type_char, 1)
    end
  end
end
