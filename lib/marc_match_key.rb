# frozen_string_literal: true

require_relative 'marc_match_key/version'
require_relative 'marc_match_key/functions'
require_relative 'marc_match_key/title_key'
require_relative 'marc_match_key/pub_date_key'
require_relative 'marc_match_key/pagination_key'
require_relative 'marc_match_key/edition_key'
require_relative 'marc_match_key/publisher_key'
require_relative 'marc_match_key/type_key'
require_relative 'marc_match_key/title_part_key'
require_relative 'marc_match_key/title_number_key'
require_relative 'marc_match_key/author_key'
require_relative 'marc_match_key/title_date_key'
require_relative 'marc_match_key/gov_doc_key'
require_relative 'marc_match_key/format_character_key'
require_relative 'marc_match_key/key'

require 'marc'
require 'nokogiri'

### A collection of functions and classes to generate a match key based on the
###   GoldRush algorithm
module MarcMatchKey
  include MarcMatchFunctions
  class Error < StandardError; end
  # Your code goes here...
end
