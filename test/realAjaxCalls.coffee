module "realAjaxCalls array tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "realAjaxCalls array correctly collects real ajax calls", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxCalls = $.fauxjax.realAjaxCalls()
      equal(realAjaxCalls.length, 1, "incorrect number of real ajax calls in realAjaxCalls array")
      equal(realAjaxCalls[0].type, "GET", "request has incorrect type")
      equal(realAjaxCalls[0].url, "/faux-request", "real ajax call has incorrect url")
      start()

asyncTest "realAjaxCalls array is cleared when fauxjax.clear is called", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxCalls = $.fauxjax.realAjaxCalls()
      equal(realAjaxCalls.length, 1, "incorrect number of real ajax calls in realAjaxCalls array")
      equal(realAjaxCalls[0].type, "GET", "request has incorrect type")
      equal(realAjaxCalls[0].url, "/faux-request", "real ajax call has incorrect url")
      $.fauxjax.clear()
      realAjaxCalls = $.fauxjax.realAjaxCalls()
      equal(realAjaxCalls.length, 0, "realAjaxCalls was not properly cleared")
      start()

asyncTest "realAjaxCalls array returns nothing when no actual ajax calls occur", ->
  $.fauxjax
    type: "GET"
    url: "/faux-request"

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxCalls = $.fauxjax.realAjaxCalls()
      equal(realAjaxCalls.length, 0, "No realAjaxCalls should have occured")
      start()
