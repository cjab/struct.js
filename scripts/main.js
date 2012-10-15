require.config({
  paths: {
    CoffeeScript: "vendor/coffeescript/coffeescript",
    cs:           "vendor/require/cs",
    text:         "vendor/require/text",
    order:        "vendor/require/order",
    data:         "../data"
  }
});

define([
  "cs!app",
], function(App) {
  App.initialize();
});
