define [
  "cs!lib/struct"
],

(Struct) ->

  class TestStruct extends Struct

    constructor: (buffer) ->
      super [
        "int32 ident"
        "int32 version"
        "Vector3 scale"
        "Vector3 translate"
        "float32 boundingRadius"
        "Vector3 eyePosition"
        "int32 numSkins"
        "int32 skinWidth"
        "int32 skinHeight"
        "int32 numVerts"
        "int32 numTris"
        "int32 numFrames"
        "int32 syncType"
        "float32 size"
      ], new ArrayBuffer(128)
