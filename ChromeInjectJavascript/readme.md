# Inject Javascript into Google Chrome

Quite simply, provides a method to inject JavaScript into Google Chrome.

The method uses the IAccessible to set the value of the address bar to contain a Javascript URI Scheme:

```js
javascript:void((function(){console.log("hello world")})())
```

The code is then executed using the key sequence `{F6}{Enter}`.

## How to use example

1. Download the repository folder using [gitzip](http://kinolien.github.io/gitzip/)
2. With the script running tap `F8` or `F9`. Tapping `F8` will take significantly longer because it will execute a http request

# Using `injectJS(script,minify)`

`script`: The javascript code to execute.
`minify`: If the `script` parameter is a multiline or commented code snippet, you will want to set minify to true or leave it blank. Otherwise if your code is already minified, set this parameter to false.

Minify will send the code to a server to be converted into code which is compatible for the url bar to handle.
