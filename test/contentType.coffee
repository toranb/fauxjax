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
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    responseText: {foo: "bar"}

  $.ajax
    type: "POST"
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

test "When faux and real requests have different contentType fauxjax will not mock the xhr", (assert) ->
  done = assert.async()

  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {name: "Johnny Utah"}
    contentType: "application/json"
    responseText: {foo: "bar"}

  $.ajax
    type: "POST"
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
