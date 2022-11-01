# frozen_string_literal: true

require_relative "minisketch/version"
require "ffi"
require_relative "minisketch/ffi"

# Minisketch class
class Minisketch
  extend MinisketchFFI
  include MinisketchFFI

  attr_reader :pointer

  class Error < StandardError
  end

  # Constructor
  # @param [FFI::AutoPointer] pointer minisketch ffi pointer
  # @raise [Error]
  def initialize(pointer)
    @pointer = pointer
    raise Error, "invalid parameter specified" if @pointer.address.zero?
  end

  # Create minisketch for a given element size, implementation and capacity.
  # @param [Integer] bits
  # @param [Integer] implementation
  # @param [Integer] capacity
  # @raise [Error]
  def self.create(bits, implementation, capacity)
    pointer =
      FFI::AutoPointer.new(
        minisketch_create(bits, implementation, capacity),
        method(:minisketch_destroy)
      )
    Minisketch.new(pointer)
  end

  # Determine the maximum number of implementations available.
  # @return [Integer] maximum implementation.
  def self.implementation_max
    minisketch_implementation_max
  end

  # Determine if the a combination of bits and implementation number is available.
  # @param [Integer] bits
  # @param [Integer] implementation
  # @return [Boolean]
  def self.implementation_supported?(bits, implementation)
    result = minisketch_implementation_supported(bits, implementation)
    result == 1
  end

  # Get the element size of a sketch in bits.
  # @return [Integer]
  def bits
    minisketch_bits(@pointer)
  end

  # Get the capacity of a sketch.
  # @return [Integer]
  def capacity
    minisketch_capacity(@pointer)
  end

  # Get the implementation of a sketch.
  # @return [Integer]
  def implementation
    minisketch_implementation(@pointer)
  end

  # Set the seed for randomizing algorithm choices to a fixed value.
  # @param [Integer] seed 64-bit integer
  def set_seed(seed) # rubocop:disable all
    minisketch_set_seed(@pointer, seed)
  end

  # Clone a sketch.
  # @return [Minisketch]
  def clone
    pointer =
      FFI::AutoPointer.new(
        minisketch_clone(@pointer),
        method(:minisketch_destroy)
      )
    Minisketch.new(pointer)
  end

  # Compute the size in bytes for serializing a given sketch.
  # @return [Integer] sketch byte size.
  def serialized_size
    minisketch_serialized_size(@pointer)
  end

  # Serialize a sketch to bytes.
  # @return [String]
  def serialize
    len = serialized_size
    output = FFI::MemoryPointer.new(:uchar, len)
    minisketch_serialize(@pointer, output)
    output.read_bytes(len)
  end

  # Deserialize a sketch from bytes.
  # @param [String] bytes
  def deserialize(bytes)
    input = FFI::MemoryPointer.new(:uchar, bytes.bytesize).put_bytes(0, bytes)
    minisketch_deserialize(@pointer, input)
    self
  end

  # Add an element to a sketch.
  # @param [Integer] element
  def add(element)
    minisketch_add_uint64(@pointer, element)
  end

  # Merge the elements of another sketch into this sketch.
  # @param [Minisketch] other
  # @raise [Minisketch::Error] if merge failed.
  def merge(other)
    unless other.is_a?(Minisketch)
      raise Error, "other must be Minisketch object"
    end
    capacity = minisketch_merge(@pointer, other.pointer)
    raise Error, "merge failed" if capacity.zero?
  end

  # Decode a sketch.
  # After merging, sketch will contain every element that existed in one but not both of the input sketches.
  # It can be seen as an exclusive or operation on the set elements.
  # If the capacity of other_sketch is lower than sketch's,
  # merging reduces the capacity of sketch to that of other_sketch.
  # @param [Array(Integer)] elements
  # @return [Array(Integer, Array(Integer))] Capacity of sketch after merging and decoded elements
  def decode(max_len)
    ptr = FFI::MemoryPointer.new(:pointer, max_len)
    result = minisketch_decode(@pointer, max_len, ptr)
    raise Error, "sketch decoding failed" if result == -1
    [result, ptr.read_array_of_type(:uint64, :read_uint64, max_len)]
  end
end
