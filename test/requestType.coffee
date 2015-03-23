module "Test Fake Vs Real request method",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have different request types (legacy jQuery api) fauxjax does not fake request POST vs PATCH", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    responseContent: {foo: "bar"}

  $.ajax
    method: "PATCH"
    url: "/faux-request"
    data: {foo: "bar"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request type does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have different request methods fauxjax does not fake request POST vs GET", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    responseContent: {foo: "bar"}

  $.ajax
    method: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request method does not match real request request method. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request method does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have different request methods fauxjax does not fake request POST vs PUT", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    responseContent: {foo: "bar"}

  $.ajax
    method: "PUT"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request method does not match real request request method. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request method does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have different request methods fauxjax does not fake request POST vs PUT", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    responseContent: {foo: "bar"}

  $.ajax
    method: "PUT"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request method does not match real request request method. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request method does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have the same request methods fauxjax does fake request GET vs GET", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "GET"
    url: "/faux-request"
    responseContent: {foo: "bar"}

  $.ajax
    method: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Faux request method does match real request method. Request should have succeed")
      assert.ok(_.isEqual(data, {"foo": "bar"}))
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "Case-insensitive matching for request methods", (assert) ->
  done = assert.async()
  $.fauxjax.new
    url: "/faux-request"
    method: "GET"
    responseContent: "Uppercase"

  $.ajax
    url: "/faux-request"
    method: "get"
    error: (xhr, textStatus) ->
      assert.ok(false, "We should match request method case insensitive")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.responseText, "Uppercase", "Response text was not a match")
      done()

test "Multiple handlers can exist for the same url with different verbs", (assert) ->
  done1 = assert.async()
  done2 = assert.async()
  $.fauxjax.new
    method: "GET"
    url: "/faux-request"

  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}

  $.ajax
    method: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Handler with a GET verb does exist for this request it should be successfully mocked")
    complete: (xhr, textStatus) ->
      done1()

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Handler with a POST verb does exist for this request it should be successfully mocked")
    complete: (xhr, textStatus) ->
      done2()
