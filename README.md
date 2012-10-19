struct.js
========

struct.js is a library that makes working with binary data in the browser a
little less painful. ArrayBuffers and DataViews are great but keeping track
of offsets when dealing with complicated data structures can be tedious.  

It's tough to beat the syntax of the C language's structs when dealing with
binary data. struct.js attempts to bring c-style structs to the browser.  

A quick example:  

    var buffer = new ArrayBuffer(32);
    var data = new Struct([
      "uint8 fieldA",
      "float32 fieldB",
      "int32 fieldC[3]"
    ], buffer);

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
