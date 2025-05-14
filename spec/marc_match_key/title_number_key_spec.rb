# frozen_string_literal: true

RSpec.describe MarcMatchKey::TitleNumberKey do
  subject(:title_number_key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }
  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }

  context 'without 245$n' do
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

    it 'returns 10 underscores' do
      expect(title_number_key.key).to eq('_' * 10)
    end
  end

  context 'with multiple 245$n' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' },
                       { 'n' => "N\u{00fa}m" },
                       { 'n' => 'ero tres' }
                     ] } }
      ]
    end

    it 'returns first 10 normalized characters' do
      expect(title_number_key.key).to eq 'numero_tre'
    end
  end
end
