# frozen_string_literal: true

RSpec.describe Minisketch do
  describe "#initialize" do
    it do
      miniscketch = described_class.new(12, 0, 4)
      expect(miniscketch.bits).to eq(12)
      expect(miniscketch.capacity).to eq(4)
      expect(miniscketch.implementation).to eq(0)
      puts miniscketch.pointer
    end

    context "with invalid implementation" do
      it do
        expect { described_class.new(12, 5, 4) }.to raise_error(Minisketch::Error)
      end
    end
  end
end
