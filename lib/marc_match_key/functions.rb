# frozen_string_literal: true

### Functions used across the portions of the GoldRush key
module MarcMatchFunctions
  def strip_punctuation(string:, replace_char: ' ')
    new_string = string.dup
    new_string.gsub!('%22', replace_char)
    new_string.gsub!(/^\s*[aA]\s+/, '')
    new_string.gsub!(/^\s*[aA]n\s+/, '')
    new_string.gsub!(/^\s*[Tt]he\s+/, '')
    new_string.gsub!(/['{}]/, '')
    new_string.gsub!('&', 'and')
    new_string.gsub!(/[\u0020-\u0025\u0028-\u002f]/, replace_char)
    new_string.gsub!(/[\u003a-\u0040\u005b-\u0060]/, replace_char)
    new_string.gsub(/[\u007c\u007e\u00a9]/, replace_char)
  end

  def pad_with_underscores(string, string_length)
    new_string = string.dup.to_s # handle nil input
    new_string.gsub!(/\s+/, ' ')
    new_string.strip!
    new_string.gsub!(/\s/, '_')
    new_string[0, string_length].ljust(string_length, '_')
  end

  def trim_max_field_length(string)
    string[0..31_999]
  end

  def normalize_string(string)
    string.unicode_normalize(:nfd)
  end

  def normalize_string_and_remove_accents(string)
    string = normalize_string(string)
    string.gsub(/\p{InCombiningDiacriticalMarks}/, '')
  end
end
