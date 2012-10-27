define [
  "cs!lib/bin_array/uint8_bin_array"
  "cs!lib/bin_array/int8_bin_array"
  "cs!lib/bin_array/uint16_bin_array"
  "cs!lib/bin_array/int16_bin_array"
  "cs!lib/bin_array/uint32_bin_array"
  "cs!lib/bin_array/int32_bin_array"
  "cs!lib/bin_array/float32_bin_array"
  "cs!lib/bin_array/float64_bin_array"
],

(Uint8BinArray, Int8BinArray, Uint16BinArray, Int16BinArray, Uint32BinArray, Int32BinArray, Float32BinArray, Float64BinArray) ->


  class Field


    @PRIMITIVES:
      char8:   { size: 1, }
      uint8:   { size: 1, array: Uint8BinArray   }
      int8:    { size: 1, array: Int8BinArray    }
      uint16:  { size: 2, array: Uint16BinArray  }
      int16:   { size: 2, array: Int16BinArray   }
      uint32:  { size: 4, array: Uint32BinArray  }
      int32:   { size: 4, array: Int32BinArray   }
      float32: { size: 4, array: Float32BinArray }
      float64: { size: 8, array: Float64BinArray }



    constructor: (desc, options = {}) ->
      @typeMap = options.typeMap || {}
      @type    = desc.type
      @name    = desc.name
      @length  = desc.length ? 1

      throw "Unknown field type" if @type == null
