module "Test Fake Vs Real Request Data",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have different data fauxjax does not fake the request", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
    response:
      data: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {bar: "baz"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux data does not match real request data. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux data does not match real request data. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real request have the same data the request is successfully faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {values: [1, 2, 3]}
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {values: [1, 2, 3]}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request did not succeed and should have been successfully faked")
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data with different key orders the request is successfully faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {foo: "bar", wat: "baz"}
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {wat: "baz", foo: "bar"}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request did not succeed and should have been successfully faked")
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data JSON.stringify'd the request is successfully faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: JSON.stringify({foo: "bar", wat: "baz"})
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: JSON.stringify({wat: "baz", foo: "bar"})
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request did not succeed and should have been successfully faked")
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "Correctly matches request data when empty objects", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {}
    response:
      content: {}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request did not succeed and should have been successfully faked")
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()

test "Data can be Undefined and Null and will still be succeffully mocked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"
      data: null
    response:
      content: {}

  $.ajax
    method: "GET"
    url: "/faux-request"
    data: undefined
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request did not succeed and should have been successfully faked")
    error: (xhr, textStatus) ->
      asert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()
