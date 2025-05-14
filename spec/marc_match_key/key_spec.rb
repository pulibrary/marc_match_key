# frozen_string_literal: true

RSpec.describe MarcMatchKey::Key do
  subject(:key) do
    described_class.new(record)
  end

  let(:leader) { '01104nam a2200289 i 4500' }
  let(:record) { MARC::Record.new_from_hash('fields' => fields, 'leader' => leader) }

  let(:fields) do
    [
      { '086' => { 'ind1' => '0',
                   'ind2' => ' ',
                   'subfields' => [
                     { 'a' => 'A 1' }
                   ] } },
      { '245' => { 'ind1' => '0',
                   'ind2' => ' ',
                   'subfields' => [
                     { 'a' => 'This is a record.' }
                   ] } },
      { '300' => { 'ind1' => ' ',
                   'ind2' => ' ',
                   'subfields' => [
                     { 'a' => '2001 pages' }
                   ] } }
    ]
  end
  let(:match_key) do
    "this_is_a_record#{'_' * 54}000020011_______a#{'_' * 75}1p"
  end

  it 'returns a complete match key' do
    expect(key.key).to eq match_key
  end
end
