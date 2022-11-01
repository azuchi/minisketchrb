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
        expect { described_class.new(12, 5, 4) }.to raise_error(
          Minisketch::Error
        )
      end
    end
  end

  describe "#implementation_supported?" do
    it do
      expect(described_class.implementation_supported?(12, 0)).to be true
      expect(described_class.implementation_supported?(12, 5)).to be false
    end
  end

  describe "#implementation_max" do
    it { expect(described_class.implementation_max > 0).to be true }
  end

  describe "#set_seed" do
    it do
      minisketch = described_class.new(12, 0, 4)
      expect do
        minisketch.set_seed(Random.rand(0xffffffffffffffff))
      end.not_to raise_error
    end
  end
end
