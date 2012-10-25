define [
  "cs!lib/field/field_factory"
  "cs!lib/struct"
  "cs!lib/field/primitive_field"
  "cs!lib/field/primitive_array_field"
  "cs!lib/field/struct_field"
  "cs!lib/field/struct_array_field"
],

(FieldFactory, Struct, PrimitiveField, PrimitiveArrayField, StructField, StructArrayField) ->


  describe "FieldFactory", ->

    factory = null

    beforeEach -> factory = new FieldFactory

    describe "#build", ->

      describe "when passed a string description", ->


        describe "of primitive field", ->

          types = [
            "uint8", "int8", "uint16","int16", "uint32",
            "int32", "float32", "float64"
          ]

          for type in types
            do (type) ->

              field = null

              beforeEach -> field = factory.build("#{type} a")

              describe type, ->

                it "should return a PrimitiveField object", ->
                  expect(field.constructor).toEqual PrimitiveField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 1


        describe "of primitive array field", ->

          types = [
            "uint8", "int8", "uint16","int16", "uint32",
            "int32", "float32", "float64"
          ]

          for type in types
            do (type) ->

              field = null

              beforeEach -> field = factory.build("#{type} a[2]")

              describe type, ->

                it "should return a PrimitiveArrayField object", ->
                  expect(field.constructor).toEqual PrimitiveArrayField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 2


        describe "of struct field", ->

          SimpleStruct = null
          types        = null

          beforeEach ->
            SimpleStruct = new Struct([
              "uint8 a"
              "uint32 b"
              "float64 c[2]"
            ])

            types = {
              "SimpleStruct": SimpleStruct
            }

          for name, type of types
            do (type) ->

              field = null

              beforeEach -> field = factory.build("#{name} a", typeMap: types)

              describe name, ->

                it "should return a StructField object", ->
                  expect(field.constructor).toEqual StructField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 1


        describe "of struct field array", ->

          SimpleStruct = null
          types        = null

          beforeEach ->
            SimpleStruct = new Struct([
              "uint8 a"
              "uint32 b"
              "float64 c[2]"
            ])

            types = {
              "SimpleStruct": SimpleStruct
            }


          for name, type of types
            do (type) ->

              field = null

              beforeEach -> field = factory.build("#{name} a[5]", typeMap: types)

              describe name, ->

                it "should return a StructField object", ->
                  expect(field.constructor).toEqual StructArrayField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 5




      describe "when passed an object description", ->


        describe "of primitive field", ->

          types = [
            "uint8", "int8", "uint16","int16", "uint32",
            "int32", "float32", "float64"
          ]

          for type in types
            do (type) ->

              field = null

              beforeEach -> field = factory.build({
                name: "a",
                type: type,
                length: 1
              })

              describe type, ->

                it "should return a PrimitiveField object", ->
                  expect(field.constructor).toEqual PrimitiveField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 1


        describe "of primitive array field", ->

          types = [
            "uint8", "int8", "uint16","int16", "uint32",
            "int32", "float32", "float64"
          ]

          for type in types
            do (type) ->

              field = null

              beforeEach -> field = factory.build({
                name: "a",
                type: type,
                length: 2
              })

              describe type, ->

                it "should return a PrimitiveArrayField object", ->
                  expect(field.constructor).toEqual PrimitiveArrayField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 2


        describe "of struct field", ->

          SimpleStruct = null
          types        = null

          beforeEach ->
            SimpleStruct = new Struct([
              "uint8 a"
              "uint32 b"
              "float64 c[2]"
            ])

            types = {
              "SimpleStruct": SimpleStruct
            }

          for name, type of types
            do (type) ->

              field = null

              beforeEach -> field = factory.build({
                name: "a"
                type: type
                length: 1
              })

              describe name, ->

                it "should return a StructField object", ->
                  expect(field.constructor).toEqual StructField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 1


        describe "of struct field array", ->

          SimpleStruct = null
          types        = null

          beforeEach ->
            SimpleStruct = new Struct([
              "uint8 a"
              "uint32 b"
              "float64 c[2]"
            ])

            types = {
              "SimpleStruct": SimpleStruct
            }

          for name, type of types
            do (type) ->

              field = null

              beforeEach -> field = factory.build({
                name: "a"
                type: type
                length: 5
              })

              describe name, ->

                it "should return a StructField object", ->
                  expect(field.constructor).toEqual StructArrayField

                it "should set the name on the field object", ->
                  expect(field.name).toEqual "a"

                it "should set the type on the field object", ->
                  expect(field.type).toEqual type

                it "should set the length on the field object", ->
                  expect(field.length).toEqual 5
