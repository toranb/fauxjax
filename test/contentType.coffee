module "Test Fake Vs Real contentType",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "When faux and real requests have the same contentType fauxjax will mock the xhr", ->
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
      ok(true, "Faux request type does match real request type. Request should have succeed")
      ok(_.isEqual(data, {"foo":"bar"}))
    error: (xhr, textStatus) ->
      ok(false, "Faux request does match real request data. Request should not have returned and error")
    complete: (xhr, textStatus) ->
      start()

asyncTest "When faux and real requests have different contentType fauxjax will not mock the xhr", ->
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
      ok(false, "The contentType does not match this request should not have succeeded")
    error: (xhr, textStatus) ->
      ok(true, "The contentType does not match the request and the faux this should produce and error")
    complete: (xhr, textStatus) ->
      start()
