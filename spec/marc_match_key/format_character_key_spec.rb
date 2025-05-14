# frozen_string_literal: true

RSpec.describe MarcMatchKey::FormatCharacterKey do
  subject(:format_character_key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }

  context 'with 245$h of electronic resource' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' },
                       { 'h' => 'electronic resource' }
                     ] } }
      ]
    end

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with 590$a for electronic reproduction' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '590' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'This is an electronic reproduction.' }
                     ] } }
      ]
    end

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with 533$a for electronic reproduction' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '533' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Electronic reproduction.' }
                     ] } }
      ]
    end

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with 337$a for an electronic resource' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '337' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'computer' },
                       { 'b' => 'c' }
                     ] } }
      ]
    end

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with 007 format of computer file' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) { [{ '007' => 'C' }] }

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with SuDoc and URL' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '856' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'u' => 'https://website.com' }
                     ] } },
        { '086' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'A 1' }
                     ] } }
      ]
    end

    it 'identifies the record as electronic' do
      expect(format_character_key.key).to eq 'e'
    end
  end

  context 'with no indication of electronic resource' do
    let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' }
                     ] } }
      ]
    end

    it 'identifies the record as print' do
      expect(format_character_key.key).to eq 'p'
    end
  end
end
