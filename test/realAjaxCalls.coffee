module "realAjaxRequests array tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "realAjaxRequests array correctly collects real ajax calls", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxRequests = $.fauxjax.realAjaxRequests()
      equal(realAjaxRequests.length, 1, "incorrect number of real ajax calls in realAjaxRequests array")
      equal(realAjaxRequests[0].type, "GET", "request has incorrect type")
      equal(realAjaxRequests[0].url, "/faux-request", "real ajax call has incorrect url")
      start()

asyncTest "realAjaxRequests array is cleared when fauxjax.clear is called", ->

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxRequests = $.fauxjax.realAjaxRequests()
      equal(realAjaxRequests.length, 1, "incorrect number of real ajax calls in realAjaxRequests array")
      equal(realAjaxRequests[0].type, "GET", "request has incorrect type")
      equal(realAjaxRequests[0].url, "/faux-request", "real ajax call has incorrect url")
      $.fauxjax.clear()
      realAjaxRequests = $.fauxjax.realAjaxRequests()
      equal(realAjaxRequests.length, 0, "realAjaxRequests was not properly cleared")
      start()

asyncTest "realAjaxRequests array returns nothing when no actual ajax calls occur", ->
  $.fauxjax.newHandler
    type: "GET"
    url: "/faux-request"

  $.ajax
    type: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      realAjaxRequests = $.fauxjax.realAjaxRequests()
      equal(realAjaxRequests.length, 0, "No realAjaxRequests should have occured")
      start()
