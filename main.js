require.config({
  paths: {
    "coffee-script": "vendor/coffeescript/coffeescript",
    cs:              "vendor/require/cs"
  }
});

define(function (require) {
  return require("cs!./lib/struct");
});
