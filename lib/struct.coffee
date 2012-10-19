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


  class Struct

    @PRIMITIVE_ARRAYS:
      "uint8":   Uint8BinArray
      "int8":    Int8BinArray
      "uint16":  Uint16BinArray
      "int16":   Int16BinArray
      "uint32":  Uint32BinArray
      "int32":   Int32BinArray
      "float32": Float32BinArray
      "float64": Float64BinArray

    @TYPE_SIZE:
      uint8:   1
      int8:    1
      uint16:  2
      int16:   2
      uint32:  4
      int32:   4
      float32: 4
      float64: 8



    # Return the number of elements in array field, if the field is not an
    # array field return 0.
    _arrayFieldLength: (prop) ->
      match = prop.match(/\[(\d+)\]/)
      if match then parseInt(match[1]) else 1



    # Clean up the type string
    _cleanType: (type) ->
      (type.charAt(0).toUpperCase() + type.slice(1)).replace(/\[\d+\]/, "")



    # Clean up the property name string
    _cleanProperty: (prop) -> prop.replace(/\[\d+\]/, "")



    # Create an accessor object containing a getter and setter method for
    # the given array type.
    _buildPrimitiveArrayAccessor: (type, fieldOffset, length, buffer = @_buffer) ->
      offset = @_structOffset + fieldOffset
      array  = Struct.PRIMITIVE_ARRAYS[type.toLowerCase()]
      data   = new array(buffer, offset, length, isLittleEndian: @_isLittleEndian)
      {
        get:       -> data
        set: (val) -> (data[i] = v for v, i in val); data
      }



    # Create an accessor object containing a getter and setter method for
    # the given data type. Array data types should use _getPrimitiveArrayAccessor.
    _buildPrimitiveAccessor: (type, fieldOffset = 0, view = @_dataView) ->
      offset = @_structOffset + fieldOffset
      {
        get:       -> view["get#{type}"](offset,      @_isLittleEndian)
        set: (val) -> view["set#{type}"](offset, val, @_isLittleEndian)
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct type. Struct array data types should use
    # _getStructArrayAccessor.
    _buildStructAccessor: (type, fieldOffset = 0, view = @_dataView) ->
      constructor = @_typeMap[type]
      if not constructor
        throw "Type: '#{type}' not recognized, try defining a type mapping"
      offset      = @_structOffset + fieldOffset
      data        = new @_typeMap[type](@_buffer, offset)
      {
        get: -> data
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct array type.
    _buildStructArrayAccessor: (type, fieldOffset, length, buffer = @_buffer) ->
      constructor = @_typeMap[type]
      if not constructor
        throw "Type: '#{type}' not recognized, try defining a type mapping"
      offset = @_structOffset + fieldOffset
      data   = (new @_typeMap[type](@_buffer, offset) for i in [0...length])
      {
        get: -> data
      }



    # Get the size in bytes of a type given it's string description
    _getSizeOfField: (prop, type, length = 1) ->
      size = Struct.TYPE_SIZE[type.toLowerCase()]
      if !size
        size = this[prop].getSize()    if length == 1
        size = this[prop][0].getSize() if length > 1
      size * length



    # Build getter and setter methods for a field
    _buildAccessor: (type, fieldOffset, count) ->
      isPrimitive = !!Struct.TYPE_SIZE[type.toLowerCase()]
      if isPrimitive and count == 1
        @_buildPrimitiveAccessor(type, fieldOffset)
      else if isPrimitive and count > 1
        @_buildPrimitiveArrayAccessor(type, fieldOffset, count)
      else if count == 1
        @_buildStructAccessor(type, fieldOffset)
      else if count > 1
        @_buildStructArrayAccessor(type, fieldOffset, count)



    constructor: (fields, @_buffer, options = {}) ->
      @_isLittleEndian = options.isLittleEndian ? yes
      @_typeMap        = options.typeMap || {}
      @_structOffset   = options.offset  || 0
      @_dataView       = new DataView(@_buffer)
      fieldOffset      = 0

      for field in fields
        field = field.split " "
        type  = @_cleanType(field[0])
        prop  = @_cleanProperty(field[1])
        count = @_arrayFieldLength(field[1])

        Object.defineProperty this, prop,
          @_buildAccessor(type, fieldOffset, count)

        fieldOffset += @_getSizeOfField(prop, type, count)

      @_size = fieldOffset



    getSize: -> @_size
