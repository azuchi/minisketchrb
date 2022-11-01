# frozen_string_literal: true

RSpec.describe Minisketch do
  let(:minisketch) do
    described_class.create(12, 0, 4)
  end

  describe "#initialize" do
    it do
      miniscketch = described_class.create(12, 0, 4)
      expect(miniscketch.bits).to eq(12)
      expect(miniscketch.capacity).to eq(4)
      expect(miniscketch.implementation).to eq(0)
    end

    context "with invalid implementation" do
      it do
        expect { described_class.create(12, 5, 4) }.to raise_error(
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
      expect do
        minisketch.set_seed(Random.rand(0xffffffffffffffff))
      end.not_to raise_error
    end
  end

  describe "#minisketch_clone" do
    it do
      current = minisketch
      cloned = current.clone
      expect(cloned.pointer.address).not_to eq(0)
      expect(cloned.pointer.address).not_to eq(current.pointer.address)
    end
  end

  describe "#minisketch_serialized_size" do
    it do
      expect(minisketch.serialized_size).to eq(6)
    end
  end

  describe "#minisketch_serialize" do
    it do
      expect(minisketch.serialize.unpack1('H*')).to eq('000000000000')
    end
  end
end
