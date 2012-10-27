define [
  "cs!lib/field/field"
],

(Field) ->


  class PrimitiveField extends Field



    # Build an object containing the getter and setter that can be used to
    # access this field.
    buildAccessor: (dataView, offset, options = {}) ->
      isLittleEndian = options.isLittleEndian ? yes
      type           = @type.slice(0, 1).toUpperCase() + @type.slice(1)
      {
        get:       -> dataView["get#{type}"](offset,      isLittleEndian)
        set: (val) -> dataView["set#{type}"](offset, val, isLittleEndian)
      }



    # Get the size in bytes of this field
    getSize: -> Field.PRIMITIVES[@type.toLowerCase()].size
