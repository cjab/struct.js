({
  appDir:  "../",
  baseUrl: "scripts",
  dir:     "../build",
  paths: {
    CoffeeScript: "vendor/coffeescript/coffeescript",
    text:         "vendor/require/text",
    order:        "vendor/require/order",
    data:         "../data",
    cs:           "vendor/require/csBuild",
    csBuild:      "vendor/require/cs"
  },
  modules: [
    {
      name: "main",
      exclude: ["CoffeeScript"]
    }
  ]
})
