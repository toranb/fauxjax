module "unfiredHandlers array tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.settings = @defaultSettings
    $.fauxjax.clear()

asyncTest "Get unfired handlers", ->
  $.fauxjax.newHandler
    url: "/faux-request/1"
  $.fauxjax.newHandler
    url: "/faux-request/2"

  $.ajax
    type: "GET"
    url: "/faux-request/1"
    complete: ->
      handlersNotFired = $.fauxjax.unfiredHandlers()
      equal(handlersNotFired.length, 1, "There should be one handler that was not fired")
      equal(handlersNotFired[0].url, "/faux-request/2", "Handler has unexpected url")
      start()
