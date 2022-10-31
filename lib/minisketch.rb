# frozen_string_literal: true

require_relative "minisketch/version"
require "ffi"
require_relative "minisketch/ffi"

# Miniscketch class
class Minisketch
  extend MiniscketchFFI
  include MiniscketchFFI

  attr_reader :pointer

  class Error < StandardError
  end

  # Create minisketch for a given element size, implementation and capacity.
  # @param [Integer] bits
  # @param [Integer] implementation
  # @param [Integer] capacity
  # @raise [Error]
  def initialize(bits, implementation, capacity)
    @pointer =
      FFI::AutoPointer.new(
        minisketch_create(bits, implementation, capacity),
        method(:minisketch_destroy)
      )
    raise Error, "invalid parameter specified" if @pointer.address.zero?
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
end
