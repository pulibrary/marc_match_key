# frozen_string_literal: true

RSpec.describe 'MarcMatchFunctions' do
  include MarcMatchFunctions
  describe 'strip_punctuation' do
    let(:replace_char) { '' }

    context "when string starts with 'A'" do
      let(:string) { 'A test' }

      it 'removes the stop word' do
        expect(strip_punctuation(string: string,
                                 replace_char: replace_char)).to eq 'test'
      end
    end

    context "when string starts with 'An'" do
      let(:string) { 'An animal' }

      it 'removes the stop word' do
        expect(strip_punctuation(string: string,
                                 replace_char: replace_char)).to eq 'animal'
      end
    end

    context "when string starts with 'the'" do
      let(:string) { 'the best' }

      it 'removes the stop word' do
        expect(strip_punctuation(string: string,
                                 replace_char: replace_char)).to eq 'best'
      end
    end

    context 'when string has all replaced characters' do
      let(:string) { "Apples & p\u0022\u002aeaches %22%are g\u003bo\u005eo\u007cd in '{}p\u007ei\u00a9e" }

      it 'replaces all characters correctly' do
        expect(strip_punctuation(string: string,
                                 replace_char: replace_char)).to eq 'Applesandpeachesaregoodinpie'
      end
    end
  end

  describe 'pad_with_underscores' do
    let(:string) { 'spaces' }
    let(:string_length) { 10 }

    it 'adds underscores to make the string 10 characters long' do
      expect(pad_with_underscores(string,
                                  string_length)).to eq 'spaces____'
    end
  end

  describe 'trim_max_field_length' do
    let(:string) { 'a' * 32_001 }

    it 'makes string length 32,000 characters' do
      expect(trim_max_field_length(string).length).to eq 32_000
    end
  end

  describe 'normalize_string_and_remove_accents' do
    let(:string) { "piet\u00e1" }

    it 'normalizes to :nfd and removes acute accent' do
      expect(normalize_string_and_remove_accents(string)).to eq 'pieta'
    end
  end
end
