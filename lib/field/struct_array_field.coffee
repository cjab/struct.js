define [
  "cs!lib/field/field"
],

(Field) ->


  class StructArrayField extends Field


    buildAccessor: (dataView, offset, options = {}) ->
      data = (
        for i in [0...@length]
          @type.build(dataView.buffer, offset + (i * @type.getSize()), options)
      )
      {
        get: -> data
      }



    getSize: -> @type.getSize() * @length
