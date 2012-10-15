define [
  "cs!lib/mixins/accessorize"
],

(Accessorize) ->

  class Struct


    # Return the number of elements in array field, if the field is not an
    # array field return 0.
    _arrayFieldLength: (prop) ->
      match = prop.match(/\[(\d+)\]/)
      if match then parseInt(match[1]) else 0



    # Clean up the type string
    _cleanType: (type) ->
      (type.charAt(0).toUpperCase() + type.slice(1)).replace(/\[\d+\]/, "")



    # Clean up the property name string
    _cleanProperty: (prop) -> prop.replace(/\[\d+\]/, "")



    # Create an accessor object containing a getter and setter method for
    # the given array type.
    _getTypedArrayAccessor: (type, offset, size, buffer = @_buffer) ->
      data = new window[type + "Array"](buffer, offset, size)
      {
        get:       -> data
        set: (val) -> data.set(val)
      }



    # Create an accessor object containing a getter and setter method for
    # the given data type. Array data types should use _getTypedArrayAccessor.
    _getDataViewAccessor: (type, offset = 0, view = @_dataView) ->
      get:       -> view["get#{type}"](offset,      @_isLittleEndian)
      set: (val) -> view["set#{type}"](offset, val, @_isLittleEndian)



    # Get the size in bytes of a type given it's string description
    _getSizeOfType: (type) ->
      switch type.toLowerCase()
        when "uint8",  "int8"    then 1
        when "uint16", "int16"   then 2
        when "uint32", "int32"   then 4
        when "float32"           then 4
        when "float64"           then 8



    constructor: (fields, @_buffer, @_isLittleEndian = yes) ->
      offset     = 0
      @_dataView = new DataView(@_buffer)

      for field in fields
        field       = field.split " "
        type        = @_cleanType(field[0])
        prop        = @_cleanProperty(field[1])
        arrayLength = @_arrayFieldLength(field[1])

        accessor = null
        if arrayLength > 0
          accessor = @_getTypedArrayAccessor(type, offset, arrayLength)
          offset  += @_getSizeOfType(type) * arrayLength
        else
          accessor = @_getDataViewAccessor(type, offset)
          offset  += @_getSizeOfType(type)

        Object.defineProperty this, prop, accessor
