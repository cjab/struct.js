define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->

  class Int16BinArray extends BinArray

    @ELEMENT_SIZE = 2

    constructor: (buffer, arrayOffset, length, options = {}) ->
      super(buffer, arrayOffset, length, "Int16", options)
