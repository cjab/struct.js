define [
  "cs!lib/field"
  "cs!spec/structs/simple_struct"
],

(Field, SimpleStruct) ->

  describe "Field", ->

    field  = null
    buffer = new ArrayBuffer(16)

    describe "#constructor", ->

      describe "when passed a string", ->

        it "should parse and set the field type", ->
          field = new Field("uint8 a", buffer)
          expect(field.type).toEqual "uint8"

        it "should parse and set the field name", ->
          field = new Field("uint8 a", buffer)
          expect(field.name).toEqual "a"

        describe "that does not represent an array", ->

          it "should set the field length to 1", ->
            field = new Field("uint8 a", buffer)
            expect(field.length).toEqual 1

        describe "that represents an array", ->

          it "should parse and set the field length", ->
            field = new Field("uint8 a[5]", buffer)
            expect(field.length).toEqual 5

          it "should remove brackets from the field name", ->
            field = new Field("uint8 a[5]", buffer)
            expect(field.name).toEqual "a"

      describe "when passed an object", ->

        it "should read and set the field type", ->
          field = new Field({ type: "uint8", name: "a" }, buffer)
          expect(field.type).toEqual "uint8"

        it "should read and set the field name", ->
          field = new Field({ type: "uint8", name: "a" }, buffer)
          expect(field.name).toEqual "a"

        describe "that does not represent an array", ->

          it "should set the field length to 1", ->
            field = new Field({ type: "uint8", name: "a", length: 1 }, buffer)
            expect(field.length).toEqual 1

        describe "that represents an array", ->

          it "should read and set the field length", ->
            field = new Field({ type: "uint8", name: "a", length: 5 }, buffer)
            expect(field.length).toEqual 5



    describe "#getSize", ->

      describe "with primitive type", ->

        it "should return the size (in bytes) of the field", ->
          field = new Field({ type: "uint32", name: "a" }, buffer)
          expect(field.getSize()).toEqual 4

      describe "with array type", ->

        it "should return the size (in bytes) of the field", ->
          field = new Field({ type: "Uint32", name: "a", length: 4 }, buffer)
          expect(field.getSize()).toEqual 16

      describe "with Struct type", ->

        it "should return the size (in bytes) of the field", ->
          field = new Field({ type: SimpleStruct, name: "a" }, buffer)
          expect(field.getSize()).toEqual 8

      describe "with Struct array type", ->

        it "should return the size (in bytes) of the field", ->
          field = new Field({ type: SimpleStruct, name: "a", length: 4 }, buffer)
          expect(field.getSize()).toEqual 32



    describe "#_cleanProperty", ->

      it "should strip [<number>] from property name", ->
        field = new Field({ type: "uint8" , name: "a", length: 2 }, buffer)
        expect(field._cleanProperty("a[2]")).toEqual "a"



    describe "#_arrayFieldLength", ->

      it "should return true if the type string represents an array", ->
        field = new Field({ type: "uint8" , name: "a", length: 5 }, buffer)
        expect(field._arrayFieldLength("a[5]")).toEqual 5

      it "should return false if the type string does not represent an array", ->
        field = new Field({ type: "uint8" , name: "a", length: 1 }, buffer)
        expect(field._arrayFieldLength("a")).toEqual 1



    describe "#_buildPrimitiveArrayAccessor", ->

      it "should create a getter", ->
        field = new Field({ type: "uint8" , name: "a", length: 5 }, buffer)
        accessor = field._buildPrimitiveArrayAccessor()
        expect(accessor.get).toBeTruthy()

      it "should create a setter", ->
        field = new Field({ type: "uint8" , name: "a", length: 5 }, buffer)
        accessor = field._buildPrimitiveArrayAccessor()
        expect(accessor.set).toBeTruthy()



    describe "#_buildPrimitiveAccessor", ->

      it "should create a getter", ->
        field = new Field({ type: "uint8" , name: "a" }, buffer)
        accessor = field._buildPrimitiveAccessor("Uint8", 0)
        expect(accessor.get).toBeTruthy()

      it "should create a setter", ->
        field = new Field({ type: "uint8" , name: "a" }, buffer)
        accessor = field._buildPrimitiveAccessor("Uint8", 0)
        expect(accessor.set).toBeTruthy()

      it "should return false if the type string does not represent an array", ->
        field = new Field({ type: "uint8" , name: "a" }, buffer)
        expect(field._arrayFieldLength("a")).toEqual 1
