# frozen_string_literal: true

RSpec.describe MarcMatchKey::AuthorKey do
  subject(:author_key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }
  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }

  context 'with no 1xx field' do
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

    it 'returns 20 underscores' do
      expect(author_key.key).to eq('_' * 20)
    end
  end

  context 'with multiple 1xx fields' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' },
                       { 'n' => "N\u00famero tres." }
                     ] } },
        { '100' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => "\u00c9t\u00e9" }
                     ] } },
        { '110' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Dog B.' }
                     ] } }
      ]
    end

    it 'returns normalized string padded to 20 characters' do
      expect(author_key.key).to eq "etedog_b#{'_' * 12}"
    end
  end
end
