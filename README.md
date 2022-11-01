# Minisketch binding for ruby [![Build Status](https://github.com/azuchi/minisketchrb/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/azuchi/minisketchrb/actions/workflows/main.yml) [![Gem Version](https://badge.fury.io/rb/minisketch.svg)](https://badge.fury.io/rb/minisketch)

This is a wrapper around [libminisketch](https://github.com/sipa/minisketch) for efficient set reconciliation.

## Installation

### Install libminisketch

Since this library is an FFI wrapper, `libminisketch` must be installed beforehand.

If the library is installed in an unusual location,
the environment variable [`LIBMINISKETCH`] can be used to specify the path to the library.

### Install gem
Add this line to your application's Gemfile:

```ruby
gem 'minisketch'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install minisketch

## Usage

Functions exposed in `libminisketch.h` can be accessed using the `Minisketch` class.

```ruby
require 'minisketch'

# Create new sketch
sketch = Minisketch.create(12, 0, 4)

# Add element to sketch
sketch.add(3000)
# or
sketch << 3001

# Serialize
sketch.serialize

# Decode
decoded = sketch.decode

another_sketch = Minisketch.create(12, 0, 4)
another_sketch << 3000
another_sketch << 3002

# Merge another sketch
sketch.merge(another_sketch)
```

This library has been tested based on commit [a571ba2](https://github.com/sipa/minisketch/commit/a571ba20f9dd1accab6a2309d066369878042ca6) of libminisketch.