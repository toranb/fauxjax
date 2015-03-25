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
    response:
      status: 200

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {something: "goes here"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "data does not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ["===== Fauxjax Debug Info =====",
                                            "URL: /faux-request",
                                            "[data] property does not match actual request"]))
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
      assert.ok(false, "data does not match and request should not succeed")
      done()
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(dummyConsoleLog, ["===== Fauxjax Debug Info =====",
                                            "URL: /faux-request",
                                            "[headers] property does not match actual request"]))
      done()

  return true
