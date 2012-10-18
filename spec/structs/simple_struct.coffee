define [
  "cs!lib/struct"
],

(Struct) ->

  class SimpleStruct extends Struct

    constructor: (buffer) ->
      super [
        "int32 ident"
        "int32 version"
      ], buffer
