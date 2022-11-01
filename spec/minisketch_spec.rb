# frozen_string_literal: true

RSpec.describe Minisketch do
  describe "#initialize" do
    it do
      minisketch = described_class.create(12, 0, 4)
      expect(minisketch.bits).to eq(12)
      expect(minisketch.capacity).to eq(4)
      expect(minisketch.implementation).to eq(0)
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
        new_sketch.set_seed(Random.rand(0xffffffffffffffff))
      end.not_to raise_error
    end
  end

  describe "#clone" do
    it do
      current = new_sketch
      cloned = current.clone
      expect(cloned.pointer.address).not_to eq(0)
      expect(cloned.pointer.address).not_to eq(current.pointer.address)
    end
  end

  describe "#serialized_size" do
    it { expect(new_sketch.serialized_size).to eq(6) }
  end

  describe "#serialize/deserialize" do
    it do
      serialized = new_sketch.serialize
      expect(serialized.unpack1("H*")).to eq("000000000000")
      expect(new_sketch.deserialize(serialized)).to be_a(described_class)
    end
  end

  describe "#add_uint64" do
    it do
      sketch = new_sketch
      serialized = sketch.serialize
      sketch.add(3000)
      expect(sketch.serialize).not_to eq(serialized)
    end
  end

  describe "#decode" do
    it do
      sketch = described_class.create(12, 0, 2)
      sketch.add(42)
      sketch.add(10)
      differences = sketch.decode(2)
      expect(differences.sort).to eq([10, 42])
    end
  end

  describe "sanity check" do
    it do
      # Alice's side
      sketch_a = new_sketch
      (3000..3010).each { |i| sketch_a.add(i) }
      serialized_size = sketch_a.serialized_size
      expect(serialized_size).to eq(12 * 4 / 8)
      serialized = sketch_a.serialize
      sketch_b = new_sketch
      (3002..3012).each { |i| sketch_b.add(i) }

      # Bob's side with merge
      sketch_ba = new_sketch
      sketch_ba.deserialize(serialized)
      sketch_b.merge(sketch_ba)

      _, differences = sketch_b.decode(4)
      expect(differences.length).to eq(4)
      expect(differences.sort).to eq([3000, 3001, 3011, 3012])
    end
  end

  def new_sketch
    described_class.create(12, 0, 4)
  end
end
