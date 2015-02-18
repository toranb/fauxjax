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
    type: "POST"
    url: "/faux-request/something"
    dataType: "json"
    data: {empty: "data"}
    responseText: {foo: "bar"}

  $.ajax
    type: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request url does not match real request url. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request url does not match real request url. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real requests have the same urls fauxjax does fake request", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"
    dataType: "json"
    responseText: {foo: "bar"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Faux request url does match real request url. Request should have succeed")
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request url does match real request url. Request should not have returned an error")
    complete: (xhr, textStatus) ->
      done()
