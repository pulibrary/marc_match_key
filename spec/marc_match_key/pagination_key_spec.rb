# frozen_string_literal: true

RSpec.describe MarcMatchKey::PaginationKey do
  subject(:pagination_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104naa a2200289 i 4500' }

  context 'without a 300 field' do
    let(:fields) do
      [
        { '008' => '111111t19861984' }
      ]
    end

    it 'returns 4 underscores' do
      expect(pagination_key.key).to eq '____'
    end
  end

  context 'with 300 field that has pagination below 1,000 pages' do
    let(:fields) do
      [
        { '300' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Has 300 pages' }
                     ] } }

      ]
    end

    it 'returns 4 underscores' do
      expect(pagination_key.key).to eq '____'
    end
  end

  context 'with 300 field that has pagination above 1,000 pages' do
    let(:fields) do
      [
        { '300' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Has 4001 pages' }
                     ] } }

      ]
    end

    it 'returns pagination' do
      expect(pagination_key.key).to eq '4001'
    end
  end

  context 'with 300 field that has no pagination' do
    let(:fields) do
      [
        { '300' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'Has pages' }
                     ] } }
      ]
    end

    it 'returns 4 underscores' do
      expect(pagination_key.key).to eq '____'
    end
  end
end
