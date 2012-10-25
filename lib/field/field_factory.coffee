define [
  "cs!lib/field/field"
  "cs!lib/field/primitive_field"
  "cs!lib/field/primitive_array_field"
  "cs!lib/field/struct_field"
  "cs!lib/field/struct_array_field"
],

(Field, PrimitiveField, PrimitiveArrayField, StructField, StructArrayField) ->


  class FieldFactory



    build: (desc, options = {}) ->
      typeMap = options.typeMap || {}
      desc    = @_parseFieldString(desc, typeMap) if desc.constructor == String
      type    = desc.type
      name    = desc.name
      length  = desc.length ? 1

      if @_isPrimitive(type, length)
        fieldType = PrimitiveField
      else if @_isPrimitiveArray(type, length)
        fieldType = PrimitiveArrayField
      else if length > 1
        fieldType = StructArrayField
      else
        fieldType = StructField

      new fieldType(desc, options)



    _isPrimitive: (type, length) ->
      typeof type == "string" &&
        Field.PRIMITIVES[type.toLowerCase()] && length == 1



    _isPrimitiveArray: (type, length) ->
      typeof type == "string" &&
        Field.PRIMITIVES[type.toLowerCase()] && length > 1



    # Clean up the property name string
    _cleanProperty: (prop) -> prop.replace(/\[\d+\]/, "")



    # Return the number of elements in array field, if the field is not an
    # array field return 0.
    _arrayFieldLength: (prop) ->
      match = prop.match(/\[(\d+)\]/)
      if match then parseInt(match[1]) else 1



    _parseFieldString: (field, typeMap = {}) ->
      field = field.split " "
      {
        type:   typeMap[field[0]] ? field[0]
        name:   @_cleanProperty(field[1])
        length: @_arrayFieldLength(field[1])
      }
