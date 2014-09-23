module "Test Fake Vs Real Request Type",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "When faux and real requests have different request types fauxjax does not fake request POST vs PATCH", ->
  $.fauxjax.newHandler
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
      ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      ok(true, "Faux request type does not match real request request type. Request should have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real requests have different request types fauxjax does not fake request POST vs GET", ->
  $.fauxjax.newHandler
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {empty: "data"}
    responseText: {foo: "bar"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      ok(true, "Faux request type does not match real request request type. Request should have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real requests have different request types fauxjax does not fake request POST vs PUT", ->
  $.fauxjax.newHandler
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
      ok(false, "Faux request type does not match real request request type. Request should not have succeed")
    error: (xhr, textStatus) ->
      ok(true, "Faux request type does not match real request request type. Request should have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real requests have the same request types fauxjax does fake request GET vs GET", ->
  $.fauxjax.newHandler
    type: "GET"
    url: "/faux-request"
    dataType: "json"
    responseText: {foo: "bar"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      ok(true, "Faux request type does match real request type. Request should have succeed")
      ok(_.isEqual(data, '{"foo":"bar"}'))
    error: (xhr, textStatus) ->
      ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "Case-insensitive matching for request types", ->
  $.fauxjax.newHandler
    url: "/faux-request"
    type: "GET"
    responseText: "Uppercase"

  $.ajax
    url: "/faux-request"
    type: "get"
    error: (xhr, textStatus) ->
      ok(false, "We should match request type case insensitive")
    complete: (xhr, textStatus) ->
      equal(xhr.responseText, "Uppercase", "Response text was not a match")
      start()
