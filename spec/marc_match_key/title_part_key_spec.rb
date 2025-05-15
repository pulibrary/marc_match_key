# frozen_string_literal: true

RSpec.describe MarcMatchKey::TitlePartKey do
  subject(:title_part_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104nam a2200289 i 4500' }

  context 'without 245$p' do
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

    it 'returns 30 underscores' do
      expect(title_part_key.key).to eq ('_' * 30).to_s
    end
  end

  context 'with multiple 245$p' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'record' },
                       { 'p' => 'First try.' },
                       { 'p' => 'Second part' }
                     ] } }
      ]
    end

    it 'returns first 10 normalized characters of each part' do
      expect(title_part_key.key).to eq "first_try_second_par#{'_' * 10}"
    end
  end
end
