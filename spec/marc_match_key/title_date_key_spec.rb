# frozen_string_literal: true

RSpec.describe MarcMatchKey::TitleDateKey do
  subject(:title_date_key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }
  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }

  context 'without 245$f' do
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

    it 'returns 15 underscores' do
      expect(title_date_key.key).to eq('_' * 15)
    end
  end

  context 'with 245$f' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' },
                       { 'f' => 'The year 1905 in the month of May' }
                     ] } }
      ]
    end

    it 'returns normalized string trimmed to 15 characters' do
      expect(title_date_key.key).to eq 'year_1905_in_th'
    end
  end
end
