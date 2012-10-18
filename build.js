{
  baseUrl: ".",
  name:    "vendor/almond/almond",
  paths: {
    "coffee-script": "vendor/coffeescript/coffeescript",
    "cs":            "vendor/require/cs"
  },
  include:       [ "main" ],
  exclude:       [ "coffee-script" ],
  stubModules:   [ "cs" ],
  insertRequire: [ "main" ],
  out:  "dist/struct.min.js",
  wrap: {
    startFile: "vendor/require/wrap.start",
    endFile:   "vendor/require/wrap.end"
  }
}
