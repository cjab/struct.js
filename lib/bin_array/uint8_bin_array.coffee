define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->

  class Uint8BinArray extends BinArray

    @ELEMENT_SIZE = 1

    constructor: (buffer, arrayOffset, length, options = {}) ->
      super(buffer, arrayOffset, length, "Uint8", options)
