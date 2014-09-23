module "unhandled array tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "unhandled array correctly collects real ajax calls", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      equal(unhandled.length, 1, "incorrect number of real ajax calls in unhandled array")
      equal(unhandled[0].type, "GET", "request has incorrect type")
      equal(unhandled[0].url, "/faux-request", "real ajax call has incorrect url")
      start()

asyncTest "unhandled array is cleared when fauxjax.clear is called", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      equal(unhandled.length, 1, "incorrect number of real ajax calls in unhandled array")
      equal(unhandled[0].type, "GET", "request has incorrect type")
      equal(unhandled[0].url, "/faux-request", "real ajax call has incorrect url")
      $.fauxjax.clear()
      unhandled = $.fauxjax.unhandled()
      equal(unhandled.length, 0, "unhandled was not properly cleared")
      start()

asyncTest "unhandled array returns nothing when no actual ajax calls occur", ->
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      unhandled = $.fauxjax.unhandled()
      equal(unhandled.length, 0, "No unhandled should have occured")
      start()
