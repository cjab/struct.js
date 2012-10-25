define [
  "cs!lib/field/field_factory"
],

(FieldFactory) ->


  class Struct


    # Build getter and setter methods for a field
    constructor: (description, options = {}) ->
      typeMap = options.typeMap || {}
      factory = new FieldFactory
      @fields = (factory.build(field, typeMap: typeMap) for field in description)



    # Build an object bound to the given underlying buffer
    build: (buffer, structOffset, options = {}) ->
      data        = {}
      dataView    = new DataView(buffer, structOffset)
      fieldOffset = 0

      for field in @fields
        accessor     = field.buildAccessor(dataView, fieldOffset, options)
        fieldOffset += field.getSize()
        Object.defineProperty data, field.name, accessor

      data



    getSize: -> (field.getSize() for field in @fields).reduce((a, b) -> a + b)
