module "Test Fake Vs Real Request URL",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "When faux and real requests have different urls fauxjax does not fake request", ->
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
      ok(false, "Faux request url does not match real request url. Request should not have succeed")
    error: (xhr, textStatus) ->
      ok(true, "Faux request url does not match real request url. Request should have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real requests have the same urls fauxjax does fake request", ->
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"
    dataType: "json"
    responseText: {foo: "bar"}

  $.ajax
    type: "GET"
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      ok(true, "Faux request url does match real request url. Request should have succeed")
    error: (xhr, textStatus) ->
      ok(false, "Faux request url does match real request url. Request should not have returned an error")
    complete: (xhr, textStatus) ->
      start()
