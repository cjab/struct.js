define [
  "cs!lib/field/field"
],

(Field) ->


  class PrimitiveArrayField extends Field



    # Build an object containing the getter and setter that can be used to
    # access this field.
    buildAccessor: (dataView, offset, options = {}) ->
      isLittleEndian = options.isLittleEndian ? yes
      array  = Field.PRIMITIVES[@type.toLowerCase()].array
      buffer = dataView.buffer
      data   = new array(buffer, offset, @length, isLittleEndian: isLittleEndian)
      {
        get:       -> data
        set: (val) -> (data[i] = v for v, i in val); data
      }



    # Get the size in bytes of this field
    getSize: -> Field.PRIMITIVES[@type.toLowerCase()].size * @length
