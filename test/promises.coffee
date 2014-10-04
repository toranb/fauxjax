module "Promises Tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Faked calls have access to the done promise callback", ->
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    responseText: "Told you I would come through"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).done (data, textStatus, jqXHR) ->
    equal(data, "Told you I would come through")
    start()

asyncTest "Faked calls have access to the then promise callback", ->
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    responseText: "Then do what you like"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).then (data, statusText, xhr) ->
    equal(data, "Then do what you like")
    start()

asyncTest "Faked calls have access to the fail promise callback", ->
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    status: 404
    statusText: "Request failed"
    isTimeout: true

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).fail (jqXHR, textStatus, errorThrown) ->
    equal(errorThrown, "Request failed")
    start()

asyncTest "Faked calls have access to the always promise callback", ->
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    isTimeout: true
    responseText: "Old faithful"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).always (jqXHR, textStatus, errorThrown) ->
    equal(jqXHR.responseText, "Old faithful")
    start()
