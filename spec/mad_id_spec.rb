require 'spec_helper'

class Pony < ActiveRecord::Base
  include MadId
end

class LittlePony < Pony
  identify_with :pny
end

describe MadId do

  it 'inserts #identify_with' do
    expect(Pony.respond_to?(:identify_with)).to be(true)
  end

  it 'wont set any callbacks' do
    expect(Pony._save_callbacks.select {|cb| cb.filter == :set_identifier}).to be_empty
  end

  describe 'when #identify_with is called' do
    subject { LittlePony.new }

    it 'inserts the #set_identifier callback' do
      expect(LittlePony._save_callbacks.select {|cb| cb.filter == :set_identifier}).to have(1).item
    end

    describe '#to_param' do
      before { subject.set_identifier }
      it 'will return the identifier' do
        expect(subject.to_param).to eq(subject.identifier)
      end
    end

    describe '#short_identifier' do
      before { subject.set_identifier }
      it 'will shorten the identifier to the first 12 chars' do
        expect(subject.short_identifier).to eq(subject.identifier[0..11])
      end
    end

    describe '#identifier' do
      before { subject.set_identifier }
      it 'will start with the #identify_with argument' do
        expect(subject.identifier).to match(/pny-.+/)
      end
    end

    describe 'callbacks' do
      subject { LittlePony.new }

      it 'will set the identifier upon create' do
        expect{ subject.save! }.to change{ subject.identifier }.from(nil)
      end
    end

  end
end
