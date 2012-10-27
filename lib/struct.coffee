define [
  "cs!lib/field/field_factory"
],

(FieldFactory) ->


  class Struct


    # Build field objects matching the description of this struct
    constructor: (description, options = {}) ->
      typeMap = options.typeMap || {}
      factory = new FieldFactory
      @fields = (factory.build(field, typeMap: typeMap) for field in description)



    # Build an object bound to the underlying buffer
    build: (buffer, structOffset, options = {}) ->
      data          = {}
      structOffset ?= 0
      fieldOffset   = 0
      dataView      = new DataView(buffer, structOffset)

      for field in @fields
        accessor     = field.buildAccessor(dataView, fieldOffset, options)
        fieldOffset += field.getSize()
        Object.defineProperty data, field.name, accessor

      data



    # Get the size in bytes of this struct
    getSize: -> (field.getSize() for field in @fields).reduce((a, b) -> a + b)
