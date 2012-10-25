struct.js
========

struct.js is a library that makes working with binary data in the browser a
little less painful. ArrayBuffers and DataViews are great but keeping track
of offsets when dealing with complicated data structures can be tedious.  

It's tough to beat the syntax of the C language's structs when dealing with
binary data. struct.js attempts to bring c-style structs to the browser.  

A quick example:  

    var buffer     = new ArrayBuffer(32);
    var someStruct = new Struct([
      "uint8 fieldA",
      "float32 fieldB",
      "int32 fieldC[3]"
    ], buffer);

    var data = someStruct.build(buffer);

    data.fieldA = 1;
    data.fieldC[0] = 1;
    data.fieldC[1] = 2;
    data.fieldC[2] = 3;

    console.log(data.fieldA);     // -> 1
    console.log(data.fieldB);     // -> 0
    console.log(data.fieldC);     // -> [1, 2, 3]


Getting Started
---------------

* [Download](http://structjs.jabnix.net/downloads/struct.min.js) the minified
library.

* Load the script using a script tag: `<script src="struct.min.js"></script>`
  Or load the script using an AMD module loader such as
  [RequireJS](http://requirejs.org).


Field Types
-----------


### Primitives

Primitives are the standard types provided by the DataView API. These include:  

`uint8`, `int8`, `uint16`, `int16`, `uint32`, `int32`, `float32`, `float64`


### Primitive Arrays

Primitive arrays are just as they sound, arrays of primitive types.


### Structs

Structs themselves can also be used within a struct definition. For example:  

    var buffer = new ArrayBuffer(8);

    var entryStruct = new Struct({
      "uint8 id",
      "uint32 value"
    });

    var headerStruct = new Struct({
      "entryStruct entry",
      "uint8 length"
    }, { typeMap: "entryStruct": entryStruct });

    var data = headerStruct.build(buffer);

    data.entry.id    = 1
    data.entry.value = 0xdead
    data.length      = 6

Notice that you must pass a typeMap to the Struct constructor which maps the
type string in the description to the struct that it represents.


### Struct Arrays

Struct arrays behave exactly the same as primitive arrays, the only difference
being that their elements are structs.
