define [
  "cs!lib/field/field"
],

(Field) ->


  describe "Field", ->

    field    = null
    dataView = null
    accessor = null

    beforeEach ->
      field = new Field({
        type:    "uint32"
        name:    "testField"
        length:  2
      }, typeMap: { "TestType": "TestType" })
      dataView = new DataView(new ArrayBuffer(16))

    describe "#constructor", ->

      it "should set the type", ->
        expect(field.type).toEqual "uint32"

      it "should set the typeMap", ->
        expect(field.typeMap).toEqual { "TestType": "TestType" }

      it "should set the name", ->
        expect(field.name).toEqual "testField"

      it "should set the length", ->
        expect(field.length).toEqual 2

      describe "without a length", ->

        beforeEach ->
          field = new Field({ type: "uint32", name: "testField" })

        it "should set the length to 1", ->
          expect(field.length).toEqual 1

      describe "without a typeMap", ->

        beforeEach ->
          field = new Field({ type: "uint32", name: "testField" })

        it "should set the typeMap to an empty object", ->
          expect(field.typeMap).toEqual {}

