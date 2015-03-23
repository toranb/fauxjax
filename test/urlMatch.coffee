module "Test Fake Vs Real Request URL",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have different urls fauxjax does not fake request", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request/something"
      data: {empty: "data"}
    response:
      responseContent: {foo: "bar"}

  $.ajax
    method: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request url does not match real request url. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request url does not match real request url. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "When faux and real requests have the same urls fauxjax does fake request", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"
    response:
      responseContent: {foo: "bar"}

  $.ajax
    method: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Faux request url does match real request url. Request should have succeed")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request url does match real request url. Request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()
