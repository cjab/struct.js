define [
  "cs!lib/field/primitive_field"
],

(PrimitiveField) ->


  describe "PrimitiveField", ->

    field    = null
    dataView = null
    accessor = null

    beforeEach ->
      field    = new PrimitiveField(type: "uint32", name: "testField")
      dataView = new DataView(new ArrayBuffer(16))
      accessor = field.buildAccessor(dataView, 0, isLittleEndian: yes)
      dataView.setUint32(0, 0xdead)

    describe "#buildAccessor", ->

      it "should create a getter on the accessor object", ->
        expect(accessor.get()).toEqual dataView.getUint32(0, yes)

      it "should create a setter on the accessor object", ->
        accessor.set(0xbeef)
        expect(dataView.getUint32(0, yes)).toEqual 0xbeef
