# frozen_string_literal: true

RSpec.describe MarcMatchKey::GovDocKey do
  subject(:gov_doc_key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }
  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }

  context 'without 086$a' do
    let(:fields) do
      [
        { '086' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'z' => 'A 1' }
                     ] } }
      ]
    end

    it 'returns an empty character' do
      expect(gov_doc_key.key).to eq ''
    end
  end

  context 'with 086$a' do
    let(:fields) do
      [
        { '086' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Y 123.1:5' }
                     ] } }
      ]
    end

    it 'returns normalized string' do
      expect(gov_doc_key.key).to eq 'y 123 1 5'
    end
  end

  context 'with 086$a that is over 32,000 characters long' do
    let(:fields) do
      [
        { '086' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => ('a' * 32_001) }
                     ] } }
      ]
    end

    it 'returns normalized string' do
      expect(gov_doc_key.key).to eq('a' * 32_000)
    end
  end
end
