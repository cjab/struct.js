define [
  "cs!lib/field/struct_array_field"
  "cs!lib/struct"
],

(StructArrayField, Struct) ->


  describe "StructArrayField", ->

    field    = null
    dataView = null
    accessor = null

    beforeEach ->
      SimpleStruct = new Struct([
        "uint32 a"
        "uint32 b"
      ])
      field = new StructArrayField({
        type: SimpleStruct, name: "testField", length: 2
      })
      dataView = new DataView(new ArrayBuffer(32))
      accessor = field.buildAccessor(dataView, 0, isLittleEndian: yes)
      dataView.setUint32(0,  0xdead, yes)
      dataView.setUint32(4,  0xbeef, yes)
      dataView.setUint32(8,  0x1337, yes)
      dataView.setUint32(12, 0xfeed, yes)


    describe "#buildAccessor", ->

      it "should create a getter on the accessor object", ->
        expect(accessor.get()[0].a).toEqual dataView.getUint32(0,  yes)
        expect(accessor.get()[0].b).toEqual dataView.getUint32(4,  yes)
        expect(accessor.get()[1].a).toEqual dataView.getUint32(8,  yes)
        expect(accessor.get()[1].b).toEqual dataView.getUint32(12, yes)

      it "should allow editing of the object returned by the getter", ->
        accessor.get()[0].a =  5
        accessor.get()[0].b = 10
        accessor.get()[1].a = 15
        accessor.get()[1].b = 20
        expect(dataView.getUint32(0,  yes)).toEqual  5
        expect(dataView.getUint32(4,  yes)).toEqual 10
        expect(dataView.getUint32(8,  yes)).toEqual 15
        expect(dataView.getUint32(12, yes)).toEqual 20

      #TODO:
      #it "should create a setter on the accessor object", ->


    describe "#getSize", ->

      it "should return the size of the field", ->
        expect(field.getSize()).toEqual 16
