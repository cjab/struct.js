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



    constructor: (desc, @buffer, @offset = 0, options = {}) ->
      @isLittleEndian = options.isLittleEndian ? yes
      @typeMap        = options.typeMap || {}

      desc        = @_parseFieldString(desc) if desc.constructor == String
      @dataView   = new DataView(@buffer)
      @type       = desc.type
      @name       = desc.name
      @length     = desc.length ? 1

      @accessor = @_buildAccessor()



    isPrimitive: ->
      typeof @type == "string" && Field.PRIMITIVES[@type.toLowerCase()]



    _buildAccessor: () ->
      if @isPrimitive() and @length == 1
        @_buildPrimitiveAccessor()
      else if @isPrimitive() and @length > 1
        @_buildPrimitiveArrayAccessor()
      else if @length == 1
        @_buildStructAccessor()
      else if @length > 1
        @_buildStructArrayAccessor()



    # Create an accessor object containing a getter and setter method for
    # the given data type. Array data types should use _getPrimitiveArrayAccessor.
    _buildPrimitiveAccessor: () ->
      dataView = @dataView
      type     = (@type.slice(0, 1).toUpperCase() + @type.slice(1))
      offset   = @offset
      isLittleEndian = @isLittleEndian
      {
        get:       -> dataView["get#{type}"](offset,      isLittleEndian)
        set: (val) -> dataView["set#{type}"](offset, val, isLittleEndian)
      }



    # Create an accessor object containing a getter and setter method for
    # the given array type.
    _buildPrimitiveArrayAccessor: () ->
      array  = Field.PRIMITIVES[@type.toLowerCase()].array
      data   = new array(@buffer, @offset, @length, isLittleEndian: @isLittleEndian)
      {
        get:       -> data
        set: (val) -> (data[i] = v for v, i in val); data
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct type. Struct array data types should use
    # _getStructArrayAccessor.
    _buildStructAccessor: () ->
      data = new @type(@buffer, @offset)
      {
        get: -> data
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct array type.
    _buildStructArrayAccessor: () ->
      data = (new @type(@buffer, @offset) for i in [0...@length])
      {
        get: -> data
      }



    _parseFieldString: (field) ->
      field = field.split " "
      {
        type:   @typeMap[field[0]] ? field[0]
        name:   @_cleanProperty(field[1])
        length: @_arrayFieldLength(field[1])
      }



    # Clean up the property name string
    _cleanProperty: (prop) -> prop.replace(/\[\d+\]/, "")



    # Return the number of elements in array field, if the field is not an
    # array field return 0.
    _arrayFieldLength: (prop) ->
      match = prop.match(/\[(\d+)\]/)
      if match then parseInt(match[1]) else 1



    # Get the size of this field in bytes
    getSize: ->
      if @isPrimitive() && @length == 1
        Field.PRIMITIVES[@type.toLowerCase()].size * @length
      else if @isPrimitive() && @length > 1
        Field.PRIMITIVES[@type.toLowerCase()].size * @accessor.get().length
      else if @length > 1
        @accessor.get()[0].getSize() * @length
      else
        @accessor.get().getSize() * @length
