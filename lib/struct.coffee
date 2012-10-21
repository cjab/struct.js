define [
  "cs!lib/field"
],

(Field) ->


  class Struct


    # Build getter and setter methods for a field
    constructor: (description, buffer, options = {}) ->
      isLittleEndian = options.isLittleEndian ? yes
      typeMap        = options.typeMap || {}
      structOffset   = options.offset  || 0
      fieldOffset      = 0

      for field in description
        field = new Field(field, buffer, structOffset + fieldOffset,
          typeMap:        typeMap,
          isLittleEndian: isLittleEndian
        )
        Object.defineProperty this, field.name, field.accessor
        fieldOffset += field.getSize()

      @_size = fieldOffset



    getSize: -> @_size
