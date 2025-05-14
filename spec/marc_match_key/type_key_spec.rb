# frozen_string_literal: true

RSpec.describe MarcMatchKey::TypeKey do
  subject(:type_key) do
    described_class.new(record)
  end

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

  context 'with leader less than 10 characters' do
    let(:leader) { '01104naa' }

    it 'returns one underscore' do
      expect(type_key.key).to eq '_'
    end
  end

  context 'with position 6 of the leader having a diacritic' do
    let(:leader) { "01104n\u00e1m a2200289 i 4500" }

    it 'returns the type without a diacritic' do
      expect(type_key.key).to eq 'a'
    end
  end
end
