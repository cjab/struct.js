define [
],

() ->

  class BinArray extends Array


    constructor: (buffer, arrayOffset, @length, @typeName, options = {}) ->
      elementSize     = options.elementSize ? @constructor.ELEMENT_SIZE
      isLittleEndian  = isLittleEndian ? options.isLittleEndian
      dataView        = new DataView(buffer)

      super(@length)

      for i in [0...@length]
        do (i) =>
          offset = arrayOffset + (i * elementSize)
          Object.defineProperty this, i,
            get:       -> dataView["get#{typeName}"](offset,      isLittleEndian)
            set: (val) -> dataView["set#{typeName}"](offset, val, isLittleEndian)
