# frozen_string_literal: true

RSpec.describe MarcMatchKey::PublisherKey do
  subject(:publisher_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104nam a2200289 i 4500' }

  context 'with no 260 or 264 fields' do
    let(:fields) do
      [
        { '008' => '111111t1986198u' }
      ]
    end

    it 'returns 5 underscores' do
      expect(publisher_key.key).to eq '_____'
    end
  end

  context 'with 264 fields for publication and copyright' do
    let(:fields) do
      [
        { '008' => '111111t1986198u' },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '1',
                     'subfields' => [
                       { 'b' => 'publisher' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '4',
                     'subfields' => [
                       { 'b' => 'copyright' }
                     ] } }
      ]
    end

    it 'returns publisher from publication 264' do
      expect(publisher_key.key).to eq 'publi'
    end
  end

  context 'with 264 fields for copyright and distribution' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '2',
                     'subfields' => [
                       { 'b' => 'distribution' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '4',
                     'subfields' => [
                       { 'b' => 'copyright' }
                     ] } }
      ]
    end

    it 'returns publisher from copyright 264' do
      expect(publisher_key.key).to eq 'copyr'
    end
  end

  context 'with 264 fields for distribution and manufacture' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '2',
                     'subfields' => [
                       { 'b' => 'distribution' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '3',
                     'subfields' => [
                       { 'c' => 'manufacture' }
                     ] } }
      ]
    end

    it 'returns publisher from distribution 264' do
      expect(publisher_key.key).to eq 'distr'
    end
  end

  context 'with 260 field and 264 for production' do
    let(:fields) do
      [
        { '260' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'b' => 'Two sixty' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '0',
                     'subfields' => [
                       { 'b' => 'production' }
                     ] } }
      ]
    end

    it 'returns publisher from production 264' do
      expect(publisher_key.key).to eq 'produ'
    end
  end

  context 'with 260 field and 264 with no publisher' do
    let(:fields) do
      [
        { '260' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'b' => 'Two sixty' }
                     ] } },
        { '264' => { 'ind1' => ' ',
                     'ind2' => '0',
                     'subfields' => [
                       { 'a' => 'Philadelphia' }
                     ] } }
      ]
    end

    it 'returns publisher from 260 field' do
      expect(publisher_key.key).to eq 'two_s'
    end
  end

  context 'without 26x field with publisher name' do
    let(:fields) do
      [
        { '264' => { 'ind1' => ' ',
                     'ind2' => '1',
                     'subfields' => [
                       { 'a' => 'Philadelphia' }
                     ] } }
      ]
    end

    it 'returns 5 underscores' do
      expect(publisher_key.key).to eq '_____'
    end
  end
end
