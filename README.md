struct.js
========

struct.js is a library that makes working with binary data in the browser a
little less painful. ArrayBuffers and DataViews are great but keeping track
of offsets when dealing with complicated data structures can be difficult.  

It's tough to beat the syntax of the C language's structs. Struct.js attempts
to bring c-style structs to the browser.  

A quick example:  

    var buffer     = new ArrayBuffer(32);
    var someStruct = new Struct([
      "uint8 fieldA",
      "float32 fieldB",
      "int32 fieldC[3]"
    ], buffer);

    var data = someStruct.build(buffer);

    data.fieldA    = 1;
    data.fieldC[0] = 1;
    data.fieldC[1] = 2;
    data.fieldC[2] = 3;



Getting Started
---------------

* [Download](http://structjs.jabnix.net/downloads/struct.min.js) the minified
library.

* Load the script using a script tag: `<script src="struct.min.js"></script>`
  Or load the script using an AMD module loader such as
  [RequireJS](http://requirejs.org).



How does it work?
-----------------


### Defining a struct

The first step is creating an instance of `Struct`. `Struct` objects hold
a description of the data that will later be used to read from an `ArrayBuffer`.
This description must be passed in on `Struct`'s constructor:  

    var exampleStruct = new Struct([
      "uint8   type",
      "uint32  id",
      { type: "float32", name: "value", length: 1 }
    ]);

A structure description is just an array of strings, objects, or a mixture of
both strings and objects. Each element of the array represents a field of the
struct.

If the element is a string then it is of the format `"type name"` where
type is the data type and name is the name of the field. An array field
can be created by using the [] array syntax along with an array size:
`"type name[5]"`. When using a string to describe a field, if the field
type is another `Struct` then a reference to that struct must be passed
to the constructor:  

    var otherStruct = new Struct([...]);

    var exampleStruct = new Struct([
      "otherStruct a",
      "uint8 b"
    ], { typeMap: { "otherStruct": otherStruct } })

If the element is an object it should be of the format:  
`{ type: "uint8", name: "fieldName" }`

Arrays can be created by adding length to the description:  
`{ type: "uint8", name: "fieldName", length: 5 }`

Descriptions of fields with a struct type should pass the struct object as
the type:  
`{ type: otherStruct, name: "fieldName", length: 5 }`

Because the struct object itself is passed as the type, the object style of
field description doesn't require a typeMap hash.


### Accessing data from an ArrayBuffer

After creating a struct it can then be used to build a data object. Data objects
are then used to access the data on the underlying `ArrayBuffer`.

    var buffer = new ArrayBuffer(32);
    var offset = 0;
    var data   = exampleStruct.build(buffer, offset, { isLittleEndian: true });

    data.a = 1;

The first argument of `build` is the `ArrayBuffer` that the object will be
accessing. The second is an offset in bytes from the beginning of the buffer.
The third argument is an options hash which at the moment only handles
setting the endianness of the data. If the options hash isn't provided the
data is assumed to be little endian.


### What is an ArrayBuffer?

An `ArrayBuffer` object holds a chunk of binary data that can be accessed
by a javascript program. A blank buffer can be created by calling it's
constructor and passing a buffer size (in bytes):
`var buffer = new ArrayBuffer(32)`

But the more interesting way to create an ArrayBuffer is by loading a file.

    var fileUrl  = "/downloads/example.mp3";
    var buffer   = null;
    var xhr      = new XMLHttpRequest();

    xhr.responseType = "arraybuffer";
    xhr.open("GET", fileUrl);
    xhr.onload = function(e) { buffer = xhr.response; }
    xhr.send();

By setting the responseType property of the xhr object the request will return
an `ArrayBuffer` object. The returned buffer object can then be used with
struct.js.



Field Types
-----------


### Primitives

Primitives are the standard types provided by the DataView API. These include:  

`uint8`, `int8`, `uint16`, `int16`, `uint32`, `int32`, `float32`, `float64`


### Primitive Arrays

Primitive arrays are just as they sound, arrays of primitive types. All of
the listed primitive types can also be used for array fields.


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
