define [
  "cs!lib/bin_array/bin_array"
],

(BinArray) ->


  describe "BinArray", ->

    view          = null
    buffer        = null
    binArray      = null
    arrayOffset   = null
    arrayLength   = null
    arrayType     = null
    elementSize   = null

    describe "#constructor", ->

      describe "with single-byte elements", ->

        beforeEach ->
          buffer      = new ArrayBuffer(32)
          arrayOffset = 1
          arrayLength = 2
          arrayType   = "Uint8"
          elementSize = 1
          binArray = new BinArray(
            buffer,
            arrayOffset,
            arrayLength,
            arrayType,
            elementSize: elementSize
            isLittleEndian: yes
          )

        it "should set the length of the array", ->
          expect(binArray.length).toEqual arrayLength

        it "should modify the underlying buffer when setting", ->
          binArray[0] = 5
          dataView = new DataView(buffer)
          expect(dataView.getUint8(arrayOffset)).toEqual 5

        it "should modify ONLY the targeted element", ->
          binArray[0] = 1
          binArray[1] = 2
          dataView = new DataView(buffer)
          expect(dataView.getUint8(arrayOffset    )).toEqual 1
          expect(dataView.getUint8(arrayOffset + 1)).toEqual 2

        it "should get data from the underlying buffer", ->
          dataView = new DataView(buffer)
          dataView.setUint8(arrayOffset, 5)
          expect(binArray[0]).toEqual 5

        it "should be comparable to an array", ->
          expect(binArray.valueOf()).toEqual [0, 0]



      describe "with multi-byte elements", ->

        beforeEach ->
          buffer      = new ArrayBuffer(32)
          arrayOffset = 1
          arrayLength = 2
          arrayType   = "Uint32"
          elementSize = 4
          binArray = new BinArray(
            buffer,
            arrayOffset,
            arrayLength,
            arrayType,
            elementSize: elementSize
            isLittleEndian: yes
          )

        it "should set the length of the array", ->
          expect(binArray.length).toEqual arrayLength

        it "should modify the underlying buffer when setting", ->
          binArray[0] = 0xdead
          dataView    = new DataView(buffer)
          expect(dataView.getUint32(arrayOffset, yes)).toEqual 0xdead

        it "should modify ONLY the targeted element", ->
          binArray[0] = 0xdead
          binArray[1] = 0xbeef
          dataView    = new DataView(buffer)
          expect(dataView.getUint32(arrayOffset    , yes)).toEqual 0xdead
          expect(dataView.getUint32(arrayOffset + 4, yes)).toEqual 0xbeef

        it "should get data from the underlying buffer", ->
          dataView = new DataView(buffer)
          dataView.setUint32(arrayOffset, 0xdead, yes)
          expect(binArray[0]).toEqual 0xdead

        describe "with isLittleEndian flag set", ->

          it "should get data in the correct endianness", ->
            dataView = new DataView(buffer)
            dataView.setUint32(arrayOffset, 0xdead, yes)
            expect(binArray[0]).toEqual 0xdead
            dataView.setUint32(arrayOffset, 0xdead,  no)
            expect(binArray[0]).not.toEqual 0xdead

        describe "with isLittleEndian flag unset", ->

          beforeEach ->
            binArray = new BinArray(
              buffer,
              arrayOffset,
              arrayLength,
              arrayType,
              elementSize: elementSize
              isLittleEndian: no
            )

          it "should get data in the correct endianness", ->
            dataView = new DataView(buffer)
            dataView.setUint32(arrayOffset, 0xdead,  no)
            expect(binArray[0]).toEqual 0xdead
            dataView.setUint32(arrayOffset, 0xdead, yes)
            expect(binArray[0]).not.toEqual 0xdead
