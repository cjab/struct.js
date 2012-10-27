define [
  "cs!lib/field/field"
],

(Field) ->


  class StructField extends Field



    # Build an object containing the getter and setter that can be used to
    # access this field.
    buildAccessor: (dataView, offset, options = {}) ->
      data = @type.build(dataView.buffer, offset, options)
      {
        get: -> data
      }



    # Get the size in bytes of this field
    getSize: -> @type.getSize()
