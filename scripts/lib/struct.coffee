define [
  "cs!lib/mixins/accessorize"
],

(Accessorize) ->

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
    _buildTypedArrayAccessor: (type, offset, size, buffer = @_buffer) ->
      data = new window[type + "Array"](buffer, offset, size)
      {
        get:       -> data
        set: (val) -> data.set(val)
      }



    # Create an accessor object containing a getter and setter method for
    # the given data type. Array data types should use _getTypedArrayAccessor.
    _buildDataViewAccessor: (type, offset = 0, view = @_dataView) ->
      get:       -> view["get#{type}"](offset,      @_isLittleEndian)
      set: (val) -> view["set#{type}"](offset, val, @_isLittleEndian)



    # Create an accessor object containing a getter and setter method for
    # the given Struct type. Struct array data types should use
    # _getStructArrayAccessor.
    _buildStructAccessor: (type, offset = 0, view = @_dataView) ->
      data = new @_typeMap[type](@_buffer, offset)
      {
        get: -> data
      }



    # Create an accessor object containing a getter and setter method for
    # the given Struct array type.
    _buildStructArrayAccessor: (type, offset, size, buffer = @_buffer) ->
      {}
      #data = new window[type + "Array"](buffer, offset, size)
      #{
      #  get:       -> data
      #  set: (val) -> data.set(val)
      #}



    # Get the size in bytes of a type given it's string description
    _getSizeOfField: (prop, type, length = 1) ->
      size = Struct.TYPE_SIZE[type.toLowerCase()]
      size = this[prop].getSize() unless size
      size * length



    _buildAccessor: (type, offset, count) ->
      isPrimitive = !!Struct.TYPE_SIZE[type.toLowerCase()]
      if isPrimitive and count == 1
        @_buildDataViewAccessor(type, offset)
      else if isPrimitive and count > 1
        @_buildTypedArrayAccessor(type, offset, count)
      else if count == 1
        @_buildStructAccessor(type, offset)
      else if count > 1
        @_buildStructArrayAccessor(type, offset, count)



    constructor: (fields, @_buffer, options = {}) ->
      @_isLittleEndian = options.isLittleEndian ? yes
      @_typeMap        = options.typeMap || {}
      @_dataView       = new DataView(@_buffer)
      offset           = 0

      for field in fields
        field = field.split " "
        type  = @_cleanType(field[0])
        prop  = @_cleanProperty(field[1])
        count = @_arrayFieldLength(field[1])

        Object.defineProperty this, prop, @_buildAccessor(type, offset, count)

        offset  += @_getSizeOfField(prop, type, count)
