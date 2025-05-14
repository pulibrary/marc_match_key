# frozen_string_literal: true

RSpec.describe MarcMatchKey::TitleKey do
  subject(:title_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104naa a2200289 i 4500' }

  context 'without linked 880 title' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'main' },
                       { 'b' => 'b' },
                       { 'h' => 'h' },
                       { 'p' => 'p' }
                     ] } }
      ]
    end

    it 'returns the title key from the 245 field' do
      expect(title_key.key).to eq "mainbp#{'_' * 64}"
    end
  end

  context 'with linked 880 title' do
    let(:fields) do
      [
        { '245' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Main' },
                       { '6' => '880-01' }
                     ] } },
        { '880' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Μαιν' },
                       { '6' => '245-01' }
                     ] } }
      ]
    end

    it 'returns the title key from the 880 field' do
      expect(title_key.key).to eq "μαιν#{'_' * 66}"
    end
  end

  context 'with no 245 field' do
    let(:fields) do
      [
        { '100' => { 'ind1' => '0',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Main' }
                     ] } }
      ]
    end

    it 'returns 70 underscores' do
      expect(title_key.key).to eq ('_' * 70).to_s
    end
  end
end
