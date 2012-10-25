define [
  "cs!lib/field/field"
],

(Field) ->


  class PrimitiveField extends Field



    buildAccessor: (dataView, offset, options = {}) ->
      isLittleEndian = options.isLittleEndian ? yes
      type           = @type.slice(0, 1).toUpperCase() + @type.slice(1)
      {
        get:       -> dataView["get#{type}"](offset,      isLittleEndian)
        set: (val) -> dataView["set#{type}"](offset, val, isLittleEndian)
      }



    getSize: -> Field.PRIMITIVES[@type.toLowerCase()].size
