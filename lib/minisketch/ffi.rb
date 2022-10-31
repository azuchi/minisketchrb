# frozen_string_literal: true

module MiniscketchFFI
  extend FFI::Library


  ffi_lib(ENV["LIBMINISKETCH"] || "libminisketch")

  attach_function :minisketch_create, %i[uint32 uint32 size_t], :pointer
  attach_function :minisketch_destroy, [:pointer], :void
  attach_function :minisketch_bits, [:pointer], :uint32
  attach_function :minisketch_capacity, [:pointer], :size_t
  attach_function :minisketch_implementation, [:pointer], :uint32
end
