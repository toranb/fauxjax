module "Test Fake Vs Real Request Data",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have different data fauxjax does not fake the request", (assert) ->
  done = assert.async()
  expect(0)
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
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data the request is successfully faked even if mutiple handlers exist for the same url", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {values: [1, 2, 3]}
    response:
      content: {fakeResponse: "Erroneous match, post data does not match"}

  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {values: [4, 5, 6]}
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {values: [4, 5, 6]}
    success: (data, textStatus, xhr) ->
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
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data one JSON.stringify'd and the other an object the request is successfully faked", (assert) ->
  done = assert.async()
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
    data: JSON.stringify({wat: "baz", foo: "bar"})
    contentType: "application/json"
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data both JSON.stringify'd objects the request is successfully faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      contentType: "application/json"
      data: JSON.stringify({foo: "bar", wat: "baz"})
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: JSON.stringify({wat: "baz", foo: "bar"})
    contentType: "application/json"
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real request have the same data both JSON.stringify'd objects the request is successfully faked for application/vnd.api+json", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      contentType: "application/vnd.api+json"
      data: JSON.stringify({foo: "bar", wat: "baz"})
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: JSON.stringify({wat: "baz", foo: "bar"})
    contentType: "application/vnd.api+json"
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()

test "Correctly matches request data when empty objects", (assert) ->
  done = assert.async()
  expect(0)

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
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()

test "Data can be Undefined and Null and will still be succeffully mocked", (assert) ->
  done = assert.async()
  expect(0)

  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: null
    response:
      content: {}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: undefined
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()

test "Data can be text and will still be succeffully mocked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: "I am just text"
    response:
      content: {fakeResponse: "Post success"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: "I am just text"
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {"fakeResponse": "Post success"}), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()
