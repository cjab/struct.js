define [
  "cs!lib/field/field"
],

(Field) ->


  class StructField extends Field


    buildAccessor: (dataView, offset, options = {}) ->
      data = @type.build(dataView.buffer, offset, options)
      {
        get: -> data
      }



    getSize: -> @type.getSize()
