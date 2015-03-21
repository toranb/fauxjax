module "Test Fake Vs Real contentType",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have the same contentType fauxjax will mock the xhr", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    responseText: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Faux request contentType does match real request contentType. Request should have succeed")
      assert.ok(_.isEqual(data, {"foo":"bar"}))
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real requests have the same contentType fauxjax will mock a failed xhr", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    status: 400
    url: "/faux-request"
    dataType: "json"
    data: {email: "invalid@email.com"}
    contentType: "application/json"
    responseText: {email: ["Bad value"]}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {email: "invalid@email.com"}
    contentType: "application/json"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request response was 400. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(_.isEqual(xhr.responseJSON, {"email": ["Bad value"]}))
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have different contentType fauxjax will not mock the xhr", (assert) ->
  done = assert.async()

  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    responseText: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {name: "Johnny Utah"}
    contentType: "text/plain"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "The contentType does not match this request should not have succeeded")
    error: (xhr, textStatus) ->
      assert.ok(true, "The contentType does not match the request and the faux this should produce and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax can handle text/json content type", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {name: "Johnny Utah"}
    contentType: "text/json"
    responseText: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {name: "Johnny Utah"}
    contentType: "text/json"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Faux request contentType does match real request contentType. Request should have succeed")
      assert.ok(_.isEqual(data, {"foo":"bar"}))
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "Fauxjax uses the value of settings contentType if one is not provided in fauxjax new the default is application/x-www-form-urlencoded; charset=UTF-8 testing defaults", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    status: 200
    data: {name: "Johnny Utah"}
    responseText: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    success: ->
      assert.ok(false, "Fauxjax should not have responsed with a success request because contentType does not match")
    error: (xhr) ->
      assert.ok(true, "Fauxjax did not return the correct response data")
    complete: ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax uses the value of settings contentType if one is not provided in fauxjax new the default is application/x-www-form-urlencoded; charset=UTF-8 testing matching with settings", (assert) ->
  done = assert.async()
  $.fauxjax.settings.contentType = "application/json"
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    status: 400
    data: {email: "invalidemail"}
    responseText: {email: ["Bad value"]}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {"email": "invalidemail"}
    contentType: "application/json"
    success: ->
      assert.ok(false, "Fauxjax should not have returned a success status was intended to be 400")
    error: (xhr) ->
      assert.ok(_.isEqual(xhr.responseJSON, {"email": ["Bad value"]}), "Fauxjax did not return the correct response data")
    complete: ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax uses the value of settings contentType if one is not provided in fauxjax new the default is application/x-www-form-urlencoded; charset=UTF-8 testing non-matching with settings", (assert) ->
  done = assert.async()
  $.fauxjax.settings.contentType = "application/json"
  $.fauxjax.new
    method: "POST"
    url: "/faux-request"
    status: 400
    data: {email: "invalidemail"}
    responseText: {email: ["Bad value"]}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {"email": "invalidemail"}
    success: ->
      assert.ok(false, "Fauxjax should not have returned a success contentType should not have matched")
    error: (xhr) ->
      assert.ok(true)
    complete: ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true
