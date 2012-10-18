define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->

  class Float64BinArray extends BinArray

    @ELEMENT_SIZE = 8

    constructor: (buffer, arrayOffset, length, options = {}) ->
      super(buffer, arrayOffset, length, options)
