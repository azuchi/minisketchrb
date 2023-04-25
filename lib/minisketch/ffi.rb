# frozen_string_literal: true

# FFIs for libminisketch
module MinisketchFFI
  extend FFI::Library

  ffi_lib(ENV["LIBMINISKETCH"] || "libminisketch")

  attach_function :minisketch_create, %i[uint32 uint32 size_t], :pointer
  attach_function :minisketch_destroy, [:pointer], :void
  attach_function :minisketch_bits, [:pointer], :uint32
  attach_function :minisketch_capacity, [:pointer], :size_t
  attach_function :minisketch_implementation, [:pointer], :uint32
  attach_function :minisketch_implementation_supported, %i[uint32 uint32], :int
  attach_function :minisketch_implementation_max, [], :uint32
  attach_function :minisketch_set_seed, %i[pointer uint64], :void
  attach_function :minisketch_clone, [:pointer], :pointer
  attach_function :minisketch_serialized_size, [:pointer], :size_t
  attach_function :minisketch_serialize, %i[pointer pointer], :void
  attach_function :minisketch_deserialize, %i[pointer pointer], :void
  attach_function :minisketch_add_uint64, %i[pointer uint64], :void
  attach_function :minisketch_merge, %i[pointer pointer], :size_t
  attach_function :minisketch_decode, %i[pointer size_t pointer], :size_t
  attach_function :minisketch_compute_capacity,
                  %i[uint32 size_t uint32],
                  :size_t
  attach_function :minisketch_compute_max_elements,
                  %i[uint32 size_t uint32],
                  :size_t
end
