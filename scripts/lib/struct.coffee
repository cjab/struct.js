define [
],

() ->

  class Struct

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
    _buildTypedArrayAccessor: (type, fieldOffset, length, buffer = @_buffer) ->
      offset = @_structOffset + fieldOffset
      data   = new window[type + "Array"](buffer, offset, length)
      {
        get:       -> data
        set: (val) -> data.set(val)
      }



    # Create an accessor object containing a getter and setter method for
    # the given data type. Array data types should use _getTypedArrayAccessor.
    _buildDataViewAccessor: (type, fieldOffset = 0, view = @_dataView) ->
      offset = @_structOffset + fieldOffset
      {
        get:       -> view["get#{type}"](offset,      @_isLittleEndian)
        set: (val) -> view["set#{type}"](offset, val, @_isLittleEndian)
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct type. Struct array data types should use
    # _getStructArrayAccessor.
    _buildStructAccessor: (type, fieldOffset = 0, view = @_dataView) ->
      offset = @_structOffset + fieldOffset
      data   = new @_typeMap[type](@_buffer, offset)
      {
        get: -> data
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct array type.
    _buildStructArrayAccessor: (type, fieldOffset, length, buffer = @_buffer) ->
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
        @_buildDataViewAccessor(type, fieldOffset)
      else if isPrimitive and count > 1
        @_buildTypedArrayAccessor(type, fieldOffset, count)
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
