# frozen_string_literal: true

require_relative "minisketch/version"
require "ffi"
require_relative "minisketch/ffi"

# Miniscketch class
class Minisketch
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
        MiniscketchFFI.minisketch_create(bits, implementation, capacity),
        MiniscketchFFI.method(:minisketch_destroy)
      )
    raise Error, "invalid parameter specified" if @pointer.address.zero?
  end

  # Get the element size of a sketch in bits.
  # @return [Integer]
  def bits
    MiniscketchFFI.minisketch_bits(@pointer)
  end

  # Get the capacity of a sketch.
  # @return [Integer]
  def capacity
    MiniscketchFFI.minisketch_capacity(@pointer)
  end

  # Get the implementation of a sketch.
  # @return [Integer]
  def implementation
    MiniscketchFFI.minisketch_implementation(@pointer)
  end
end
