module "Test matches when strict matching is turned off",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
    $.fauxjax.settings.strictMatching = false
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux request has no data and real request does fauxjax does fake request with strict matching set to false", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
    response:
      content: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Strict mode set to false. Request should succeed")
    error: (xhr, textStatus) ->
      assert.ok(false, "Strict mode set to false. Request should succeed")
    complete: (xhr, textStatus) ->
      done()

test "When faux request has data and real request does not fauxjax does not fake request with strict matching set to false", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {empty: "data"}
    response:
      content: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux has data and request does not. Request should not succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux has data and request does not. Request should not succeed")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux request has no method fauxjax does fake request", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request"
    response:
      content: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "No method provided on faux. Request should succeed")
    error: (xhr, textStatus) ->
      assert.ok(false, "No method provided on faux. Request should succeed")
    complete: (xhr, textStatus) ->
      done()

test "When faux request has no request headers and real request does fauxjax does fake request with strict matching set to false", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
    response:
      content: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Strict mode set to false. Request should succeed")
    error: (xhr, textStatus) ->
      assert.ok(false, "Strict mode set to false. Request should succeed")
    complete: (xhr, textStatus) ->
      done()

