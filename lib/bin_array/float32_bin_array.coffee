define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->

  class Float32BinArray extends BinArray

    @ELEMENT_SIZE = 4

    constructor: (buffer, arrayOffset, length, options = {}) ->
      super(buffer, arrayOffset, length, options)
