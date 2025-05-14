# frozen_string_literal: true

RSpec.describe MarcMatchKey::PubDateKey do
  subject(:pub_date_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104naa a2200289 i 4500' }

  context 'with valid date2 in 008' do
    let(:fields) do
      [
        { '008' => '111111t19861984' }
      ]
    end

    it 'returns date2 from 008' do
      expect(pub_date_key.key).to eq '1984'
    end
  end

  context 'with valid date2 in 008 that specifies a reprint' do
    let(:fields) do
      [
        { '008' => '111111r19861984' }
      ]
    end

    it 'returns date1 from 008' do
      expect(pub_date_key.key).to eq '1986'
    end
  end

  context 'with invalid date2 in 008 and no 26x' do
    let(:fields) do
      [
        { '008' => '111111t1986198u' }
      ]
    end

    it 'returns 0000' do
      expect(pub_date_key.key).to eq '0000'
    end
  end

  context 'with invalid date2 in 008 and 264s for publication and copyright' do
    let(:fields) do
      [
        { '008' => '111111t1986198u' },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '1',
                     'subfields' => [
                       { 'c' => '1981' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '4',
                     'subfields' => [
                       { 'c' => '1983' }
                     ] } }
      ]
    end

    it 'returns date from publication 264' do
      expect(pub_date_key.key).to eq '1981'
    end
  end

  context 'with no 008 and 264s for copyright and distribution' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '2',
                     'subfields' => [
                       { 'c' => '1982' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '4',
                     'subfields' => [
                       { 'c' => '1984' }
                     ] } }
      ]
    end

    it 'returns date from copyright 264' do
      expect(pub_date_key.key).to eq '1984'
    end
  end

  context 'with no 008 and 264s for distribution and manufacture' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '2',
                     'subfields' => [
                       { 'c' => '1982' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '3',
                     'subfields' => [
                       { 'c' => '1983' }
                     ] } }
      ]
    end

    it 'returns date from distribution 264' do
      expect(pub_date_key.key).to eq '1982'
    end
  end

  context 'with no 008, 260 field, and 264 for production' do
    let(:fields) do
      [
        { '260' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'c' => '1960' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '0',
                     'subfields' => [
                       { 'c' => '1980' }
                     ] } }
      ]
    end

    it 'returns date from production 264' do
      expect(pub_date_key.key).to eq '1980'
    end
  end

  context 'with no 008, 260 field, and 264 with no date' do
    let(:fields) do
      [
        { '260' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'c' => '1960' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '0',
                     'subfields' => [
                       { 'a' => 'Philadelphia' }
                     ] } }
      ]
    end

    it 'returns date from 260 field' do
      expect(pub_date_key.key).to eq '1960'
    end
  end

  context 'with no 008 or 26x field with date' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '1',
                     'subfields' => [
                       { 'a' => 'Philadelphia' }
                     ] } }
      ]
    end

    it 'returns 0000' do
      expect(pub_date_key.key).to eq '0000'
    end
  end
end
