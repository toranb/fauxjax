module "Debugging Tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
    $.fauxjax.settings.debug = true
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When debug set to true expected info is logged when data does not match", (assert) ->
  done = assert.async()
  dummyConsoleLog = []

  monkeyConsole = (theString) ->
    dummyConsoleLog.push(theString)

  console.log = monkeyConsole

  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    response:
      status: 200

  $.ajax
    method: "POST"
    url: "/faux-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    data: {something: "goes here"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "data does not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ['===== Fauxjax Debug Info =====',
                                            '*Real Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/x-www-form-urlencoded',
                                            '    Headers:     Authorization,Basic SmFycm9kQ1RheWxvcjpwYXNzd29yZDE=',
                                            '    Data:        {"something":"goes here"}',
                                            '*Mock Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/x-www-form-urlencoded',
                                            '    Headers:     Authorization,Basic SmFycm9kQ1RheWxvcjpwYXNzd29yZDE=',
                                            '    Data:        undefined']))
      done()
  return true

test "When debug set to true expected info is logged when nested data does not match", (assert) ->
  done = assert.async()
  dummyConsoleLog = []

  monkeyConsole = (theString) ->
    dummyConsoleLog.push(theString)

  console.log = monkeyConsole

  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    response:
      status: 200

  $.ajax
    method: "POST"
    url: "/faux-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    data: {something: "goes here", other: {nested: "data"}}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "data does not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ['===== Fauxjax Debug Info =====',
                                            '*Real Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/x-www-form-urlencoded',
                                            '    Headers:     Authorization,Basic SmFycm9kQ1RheWxvcjpwYXNzd29yZDE=',
                                            '    Data:        {"something":"goes here","other":{"nested":"data"}}',
                                            '*Mock Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/x-www-form-urlencoded',
                                            '    Headers:     Authorization,Basic SmFycm9kQ1RheWxvcjpwYXNzd29yZDE=',
                                            '    Data:        undefined']))
      done()
  return true

test "When debug set to true expected info is logged when headers do not match", (assert) ->
  done = assert.async()
  dummyConsoleLog = []

  monkeyConsole = (theString) ->
    dummyConsoleLog.push(theString)

  console.log = monkeyConsole

  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"
    response:
      status: 200
      content: {status: "success"}

  $.ajax
    method: "GET"
    url: "/faux-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "headers do not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ["===== Fauxjax Debug Info =====",
                                            "*Real Request*",
                                            "    URL:         /faux-request",
                                            "    Type:        GET",
                                            "    contentType: application/x-www-form-urlencoded",
                                            "    Headers:     Authorization,Basic SmFycm9kQ1RheWxvcjpwYXNzd29yZDE=",
                                            "    Data:        undefined",
                                            "*Mock Request*",
                                            "    URL:         /faux-request",
                                            "    Type:        GET",
                                            "    contentType: application/x-www-form-urlencoded",
                                            "    Headers:     ",
                                            "    Data:        undefined"]))
      done()

  return true

test "When debug set to true expected info is logged when contentType do not match", (assert) ->
  done = assert.async()
  dummyConsoleLog = []

  monkeyConsole = (theString) ->
    dummyConsoleLog.push(theString)

  console.log = monkeyConsole

  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      contentType: "application/json"
      data: {foo: "bar", wat: "baz"}
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {foo: "bar", wat: "baz"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "data does not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ['===== Fauxjax Debug Info =====',
                                            '*Real Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/x-www-form-urlencoded',
                                            '    Headers:     ',
                                            '    Data:        {"foo":"bar","wat":"baz"}'
                                            '*Mock Request*',
                                            '    URL:         /faux-request',
                                            '    Type:        POST',
                                            '    contentType: application/json',
                                            '    Headers:     ',
                                            '    Data:        {"foo":"bar","wat":"baz"}']))
      done()

  return true
