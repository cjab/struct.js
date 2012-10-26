define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->

  class Int8BinArray extends BinArray

    @ELEMENT_SIZE = 1

    constructor: (buffer, arrayOffset, length, options = {}) ->
      super(buffer, arrayOffset, length, "Int8", options)
