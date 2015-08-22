module "Header Tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Fauxjax request correctly returns text when string is provided for content", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {some: "post"}
    response:
      content: "<div>WINNING</div>"

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {some: "post"}
    success: (data, textStatus, xhr) ->
      assert.equal(data, "<div>WINNING</div>", "Returned HTML does not match faked request")
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.getResponseHeader("Content-Type"), "text", "Incorrect content type was returned from faked call")
      done()

test "Fauxjax request correctly returns json when object is provided for content", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {filler: "text"}
    response:
      content: {foo: "bar", baz: {car: "far"}}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {filler: "text"}
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {foo: "bar", baz: {car: "far"}}, "Returned json does not match"))
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr) ->
      assert.equal(xhr.getResponseHeader("Content-Type"), "json", "Incorrect context type was returned from faked call")
      done()

test "Fauxjax can set additional response headers", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/fauxjax-request"
    response:
      headers: {"Something-Useful": "yes"}
      content: "done"

  $.ajax
    method: "GET"
    url: "/fauxjax-request"
    error: (xhr, textStatus) ->
      assert.ok(false, "Request should have been successfully faked")
    success: (data, textStatus, xhr) ->
      assert.equal(data, "done", "Request response didn't not match the fake")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.getResponseHeader("Something-Useful"), "yes", "Additional header is not present")
      done()

test "Fauxjax will not mock request if request headers do not match", (assert) ->
  done = assert.async()
  expect(0)

  $.fauxjax.new
    request:
      method: "GET"
      url: "/fauxjax-request"
    response:
      content: {status: "success"}

  $.ajax
    method: "GET"
    url: "/fauxjax-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Request should not have been mocked. Headers didn't match")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax will mock request when request headers do match", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/fauxjax-request"
      headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    response:
      content: {status: "success"}

  $.ajax
    method: "GET"
    url: "/fauxjax-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    error: (xhr, textStatus) ->
      assert.ok(false, "Request should have been mocked. Headers do match")
    success: (data, textStatus, xhr) ->
      assert.ok(_.isEqual(data, {"status": "success"}), "Response text not a match received: #{data}")
    complete: (xhr, textStatus) ->
      done()
