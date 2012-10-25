define [
  "cs!lib/field/struct_field"
  "cs!lib/struct"
],

(StructField, Struct) ->


  describe "StructField", ->

    field    = null
    dataView = null
    accessor = null

    beforeEach ->
      SimpleStruct = new Struct([
        "uint32 a"
        "uint32 b"
      ])
      field = new StructField({
        type: SimpleStruct, name: "testField", length: 1
      })
      dataView = new DataView(new ArrayBuffer(16))
      accessor = field.buildAccessor(dataView, 0, isLittleEndian: yes)
      dataView.setUint32(0, 0xdead)
      dataView.setUint32(4, 0xbeef)


    describe "#buildAccessor", ->

      it "should create a getter on the accessor object", ->
        expect(accessor.get().a).toEqual dataView.getUint32(0, yes)
        expect(accessor.get().b).toEqual dataView.getUint32(4, yes)

      it "should allow editing of the object returned by the getter", ->
        accessor.get().a = 0x1337
        accessor.get().b = 0xfeed
        expect(dataView.getUint32(0, yes)).toEqual 0x1337
        expect(dataView.getUint32(4, yes)).toEqual 0xfeed

      #TODO:
      #it "should create a setter on the accessor object", ->


    describe "#getSize", ->

      it "should return the size of the field", ->
        expect(field.getSize()).toEqual 8
