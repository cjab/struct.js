define [
  "cs!lib/field/primitive_array_field"
],

(PrimitiveArrayField) ->


  describe "PrimitiveArrayField", ->

    field    = null
    dataView = null
    accessor = null

    beforeEach ->
      field    = new PrimitiveArrayField({
        type: "uint32", name: "testField", length: 2
      })
      dataView = new DataView(new ArrayBuffer(16))
      accessor = field.buildAccessor(dataView, 0, isLittleEndian: yes)
      dataView.setUint32(0, 0xdead)
      dataView.setUint32(4, 0xbeef)

    describe "#buildAccessor", ->

      it "should create a getter on the accessor object", ->
        expect(accessor.get()[0]).toEqual dataView.getUint32(0, yes)
        expect(accessor.get()[1]).toEqual dataView.getUint32(4, yes)

      it "should create a getter that can be indexed", ->
        accessor.get()[0] = 0x1337
        accessor.get()[1] = 0xfeed
        expect(dataView.getUint32(0, yes)).toEqual 0x1337
        expect(dataView.getUint32(4, yes)).toEqual 0xfeed

      it "should create a setter on the accessor object", ->
        data = [ 0x1337, 0xfeed ]
        accessor.set(data)
        expect(dataView.getUint32(0, yes)).toEqual 0x1337
        expect(dataView.getUint32(4, yes)).toEqual 0xfeed
