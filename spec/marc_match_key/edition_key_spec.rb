# frozen_string_literal: true

RSpec.describe MarcMatchKey::EditionKey do
  subject(:edition_key) do
    described_class.new(record)
  end

  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }
  let(:leader) { '01104nam a2200289 i 4500' }

  context 'without 250$a' do
    let(:fields) do
      [
        { '250' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { '3' => 'First work' }
                     ] } }
      ]
    end

    it 'returns first edition key padded with underscores' do
      expect(edition_key.key).to eq '1__'
    end
  end

  context 'with 250$a with numbers 1-3 in word form' do
    let(:fields) do
      [
        { '250' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'random firthisec' }
                     ] } }
      ]
    end

    it 'returns numbers' do
      expect(edition_key.key).to eq '132'
    end
  end

  context 'with 250$a with numbers 4-6 in word form' do
    let(:fields) do
      [
        { '250' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'foufivsixlaugh' }
                     ] } }
      ]
    end

    it 'returns numbers' do
      expect(edition_key.key).to eq '456'
    end
  end

  context 'with 250$a with numbers 7-9 in word form' do
    let(:fields) do
      [
        { '250' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => 'seveignin' }
                     ] } }
      ]
    end

    it 'returns numbers' do
      expect(edition_key.key).to eq '789'
    end
  end

  context 'with 250$a with 2-letter word' do
    let(:fields) do
      [
        { '250' => { 'ind1' => ' ',
                     'ind2' => ' ',
                     'subfields' => [
                       { 'a' => '!ok' }
                     ] } }
      ]
    end

    it 'returns 2-letter word with padding' do
      expect(edition_key.key).to eq 'ok_'
    end
  end
end
