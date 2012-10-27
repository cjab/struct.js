define [
  "cs!lib/field/field"
],

(Field) ->


  class StructArrayField extends Field



    # Build an object containing the getter and setter that can be used to
    # access this field.
    buildAccessor: (dataView, offset, options = {}) ->
      data = (
        for i in [0...@length]
          @type.build(dataView.buffer, offset + (i * @type.getSize()), options)
      )
      {
        get: -> data
      }



    # Get the size in bytes of this field
    getSize: -> @type.getSize() * @length
