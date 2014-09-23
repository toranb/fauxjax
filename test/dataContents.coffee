module "Test Fake Vs Real Request Data",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "When faux and real requests have different data fauxjax does not fake the request", ->
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    data: {foo: "bar"}

  $.ajax
    type: "POST"
    url: "/faux-request"
    data: {bar: "baz"}
    success: (data, textStatus, xhr) ->
      ok(false, "Faux data does not match real request data. Request should not have succeed")
    error: (xhr, textStatus) ->
      ok(true, "Faux data does not match real request data. Request should have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real request have the save data request is successfully faked", ->
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    data: {values: [1, 2, 3]}
    responseText: {fakeResponse: "Post success"}

  $.ajax
    type: "POST"
    url: "/faux-request"
    data: {values: [1, 2, 3]}
    success: (data, textStatus, xhr) ->
      ok(true, "Request did not succeed and should have been successfully faked")
      ok(_.isEqual(data, '{"fakeResponse":"Post success"}'), "Response text not a match received: #{data}")
    error: (xhr, textStatus) ->
      ok(false, "Faux data does match the real request data. The request should not have returned an error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "Correctly matches request data when empty objects", ->
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    data: {}
    responseText: {}

  $.ajax
    type: "POST"
    url: "/faux-request"
    data: {}
    success: (data, textStatus, xhr) ->
      ok(true, "Request did not succeed and should have been successfully faked")
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      start()
