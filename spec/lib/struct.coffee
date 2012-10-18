define [
  "cs!lib/struct"
  "cs!spec/structs/test_struct"
  "cs!spec/structs/simple_struct"
],

(Struct, TestStruct, SimpleStruct) ->


  describe "Struct", ->

    description = null
    struct      = null
    view        = null
    buffer      = null
    typeMap     = null

    beforeEach ->
      description = [
        "uint8 testField"
      ]
      struct = new Struct(description, new ArrayBuffer(4))


    describe "#constructor", ->

      it "should define a new field based on the description string", ->
        expect(struct.testField).toEqual 0

      it "should not define fields that were not in the description", ->
        expect(struct.testField2).toBeUndefined()


      describe "with a single field", ->

        beforeEach ->
          description = [ "uint8 a" ]
          buffer      = new ArrayBuffer(4)
          struct      = new Struct(description, buffer)
          view        = new DataView(buffer)

        it "should create a getter and setter with a 0 offset", ->
          struct.a = 5
          expect(struct.a).toEqual view.getUint8(0)


      describe "with multiple fields", ->

        beforeEach ->
          description = [
            "uint8 a"
            "float64 b"
            "int32 c"
          ]
          buffer      = new ArrayBuffer(32)
          struct      = new Struct(description, buffer)
          view        = new DataView(buffer)

        it "should create a getter and setter with the correct offset", ->
          struct.a =  5
          struct.b =  1234.1234
          struct.c = -5
          expect(struct.a).toEqual view.getUint8(0)
          expect(struct.b).toEqual view.getFloat64(1, yes)
          expect(struct.c).toEqual view.getInt32(9,   yes)



      describe "with an array field", ->

        beforeEach ->
          description = [
            "uint8 a[2]"
            "float64 b"
            "int32 c"
          ]
          buffer      = new ArrayBuffer(32)
          struct      = new Struct(description, buffer)
          view        = new DataView(buffer)

        it "should create a getter and setter with the correct offset", ->
          struct.a[0] =  1
          struct.a[1] =  2
          struct.b    =  1234.1234
          struct.c    = -5
          expect(struct.a[0]).toEqual view.getUint8(0)
          expect(struct.a[1]).toEqual view.getUint8(1)
          expect(struct.b).toEqual    view.getFloat64(2, yes)
          expect(struct.c).toEqual    view.getInt32(10,  yes)

        it "should copy array values if array is assigned", ->
          struct.a = [3, 4]
          expect(struct.a[0]).toEqual 3
          expect(struct.a[1]).toEqual 4
          expect(struct.a[0]).toEqual view.getUint8(0)
          expect(struct.a[1]).toEqual view.getUint8(1)


      describe "with a Struct field", ->

        beforeEach ->

          description = [
            "uint8 a"
            "SimpleStruct b"
            "uint8 c"
          ]
          typeMap     = "SimpleStruct": SimpleStruct
          buffer      = new ArrayBuffer(1024)
          struct      = new Struct(description, buffer,
                                   typeMap: typeMap, offset: 0)
          view        = new DataView(buffer)

        it "should create a nested struct object", ->
          expect(struct.b.ident).toEqual 0

        it "should offset the following field correctly", ->
          offset   = struct.b.getSize() + 1
          expect(view.getUint8(offset)).toEqual struct.c


      describe "with a Struct array field", ->

        beforeEach ->

          description = [
            "uint8 a"
            "SimpleStruct b[2]"
            "uint8 c"
          ]
          typeMap     = "SimpleStruct": SimpleStruct
          buffer      = new ArrayBuffer(1024)
          struct      = new Struct(description, buffer,
                                   typeMap: typeMap, offset: 0)
          view        = new DataView(buffer)

        it "should create a nested struct object", ->
          expect(struct.b[0].ident).toEqual 0
          expect(struct.b[1].ident).toEqual 0

        it "should offset the following field correctly", ->
          offset   = (struct.b[0].getSize() * 2) + 1
          expect(view.getUint8(offset)).toEqual struct.c


      describe "with isLittleEndian parameter set to false", ->

        it "should read values as big endian", ->
          description = [ "uint16 a" ]
          buffer      = new ArrayBuffer(32)
          struct      = new Struct(description, buffer, isLittleEndian: no)
          view        = new DataView(buffer)
          view.setUint16(0, 10, no)
          expect(struct.a).toEqual 10

      describe "with an offset", ->

        it "should read values starting from the offset", ->
          description = [ "uint8 a" ]
          buffer      = new ArrayBuffer(32)
          struct      = new Struct(description, buffer, offset: 1)
          view        = new DataView(buffer)
          view.setUint8(1, 10, yes)
          expect(struct.a).toEqual 10

      describe "without an offset", ->

        it "should default to an offset of 0", ->
          description = [ "uint8 a" ]
          buffer      = new ArrayBuffer(32)
          struct      = new Struct(description, buffer)
          view        = new DataView(buffer)
          view.setUint8(0, 10, yes)
          expect(struct.a).toEqual 10


      describe "with an array that is not offset by a multiple of it's element size", ->

        beforeEach ->

          description = [
            "uint8 a"
            "uint32 b[2]"
            "uint8 c"
          ]
          buffer      = new ArrayBuffer(1024)
          struct      = new Struct(description, buffer)
          view        = new DataView(buffer)

        it "should set values in the array", ->
          struct.b[0] = 5
          struct.b[1] = 7
          expect(view.getUint32(1, yes)).toEqual 5
          expect(view.getUint32(5, yes)).toEqual 7

        it "should get values from the array", ->
          view.setUint32(1, 5, yes)
          view.setUint32(5, 7, yes)
          expect(struct.b[0]).toEqual 5
          expect(struct.b[1]).toEqual 7



    describe "#_cleanType", ->

      it "should strip [] from type name", ->
        expect(struct._cleanType("uint8[2]")).toEqual "Uint8"

      it "should capitalize the first letter of the type name", ->
        expect(struct._cleanType("uint8")).toEqual "Uint8"



    describe "#_cleanProperty", ->

      it "should strip [<number>] from property name", ->
        expect(struct._cleanProperty("a[2]")).toEqual "a"



    describe "#_arrayFieldLength", ->

      it "should return true if the type string represents an array", ->
        expect(struct._arrayFieldLength("a[5]")).toEqual 5

      it "should return false if the type string does not represent an array", ->
        expect(struct._arrayFieldLength("a")).toEqual 1



    describe "#_buildPrimitiveArrayAccessor", ->

      it "should create a getter", ->
        accessor = struct._buildPrimitiveArrayAccessor("Uint8", 0, 2)
        expect(accessor.get).toBeTruthy()

      it "should create a setter", ->
        accessor = struct._buildPrimitiveArrayAccessor("Uint8", 0, 2)
        expect(accessor.set).toBeTruthy()



    describe "#_buildPrimitiveAccessor", ->

      it "should create a getter", ->
        accessor = struct._buildPrimitiveAccessor("Uint8", 0)
        expect(accessor.get).toBeTruthy()

      it "should create a setter", ->
        accessor = struct._buildPrimitiveAccessor("Uint8", 0)
        expect(accessor.set).toBeTruthy()

      it "should return false if the type string does not represent an array", ->
        expect(struct._arrayFieldLength("a")).toEqual 1



    describe "#getSize", ->

      describe "with only primitives", ->

        beforeEach ->
          description = [ "uint8 a", "int32 b" ]
          struct      = new Struct(description, new ArrayBuffer(4))

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 5

      describe "with primitives and primitive arrays", ->

        beforeEach ->
          description = [ "uint8 a", "uint8 b[5]", "uint32 c" ]
          struct      = new Struct(description, new ArrayBuffer(20))

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 10

      describe "with only structs", ->

        beforeEach ->
          description = [ "SimpleStruct a", "SimpleStruct b" ]
          struct      = new Struct(
                          description,
                          new ArrayBuffer(20),
                          typeMap: { "SimpleStruct": SimpleStruct }
                        )

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 16

      describe "with structs and struct arrays", ->
        beforeEach ->
          description = [ "SimpleStruct a", "SimpleStruct b[2]", "SimpleStruct c" ]
          struct      = new Struct(
                          description,
                          new ArrayBuffer(64),
                          typeMap: { "SimpleStruct": SimpleStruct }
                        )

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 32

      describe "with primitives, arrays, and structs", ->

        beforeEach ->
          description = [
                          "uint8 a"
                          "SimpleStruct b[2]"
                          "SimpleStruct c"
                          "uint8 d[4]"
                        ]
          struct      = new Struct(
                          description,
                          new ArrayBuffer(64),
                          typeMap: { "SimpleStruct": SimpleStruct }
                        )

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 29

      describe "with an array that is not offset by a multiple of it's element size", ->

        beforeEach ->
          description = [ "uint8 a", "int32 d[2]" ]
          struct      = new Struct(description, new ArrayBuffer(9))

        it "should return the sum of all fields' sizes", ->
          expect(struct.getSize()).toEqual 9