module "Test Fake Vs Real Request Type",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "When faux and real requests have different request types fauxjax does not fake request POST vs PATCH", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {empty: "data"}
    responseText: {foo: "bar"}

  $.ajax
    type: "PATCH"
    url: "/faux-request"
    data: {foo: "bar"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request type does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real requests have different request types fauxjax does not fake request POST vs GET", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {empty: "data"}
    responseText: {foo: "bar"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request type does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real requests have different request types fauxjax does not fake request POST vs PUT", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {empty: "data"}
    responseText: {foo: "bar"}

  $.ajax
    type: "PUT"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      assert.ok(true, "Faux request type does not match real request request. Request should have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "When faux and real requests have the same request types fauxjax does fake request GET vs GET", (assert) ->
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
      assert.ok(true, "Faux request type does match real request type. Request should have succeed")
      assert.ok(_.isEqual(data, '{"foo":"bar"}'))
    error: (xhr, textStatus) ->
      assert.ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      done()

test "Case-insensitive matching for request types", (assert) ->
  done = assert.async()
  $.fauxjax.new
    url: "/faux-request"
    type: "GET"
    responseText: "Uppercase"

  $.ajax
    url: "/faux-request"
    type: "get"
    error: (xhr, textStatus) ->
      assert.ok(false, "We should match request type case insensitive")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.responseText, "Uppercase", "Response text was not a match")
      done()

test "Multiple handlers can exist for the same url with different verbs", (assert) ->
  done1 = assert.async()
  done2 = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"

  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {empty: "data"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Handler with a GET verb does exist for this request it should be successfully mocked")
    complete: (xhr, textStatus) ->
      done1()

  $.ajax
    type: "POST"
    url: "/faux-request"
    data: {empty: "data"}
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Handler with a POST verb does exist for this request it should be successfully mocked")
    complete: (xhr, textStatus) ->
      done2()
