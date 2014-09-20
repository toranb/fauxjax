module "Test Fauxjax clear options",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Remove fauxjax definition by id", ->
  id = $.fauxjax(
    type: "GET"
    url: "faux-request"
    contentType: "text/plain"
    responseText: "test"
  )

  $.ajax
    url: "faux-request"
    success: (data, textStatus, xhr) ->
      equal(data, "test", "Response from fake was not what was expected")
    error: (xhr, textStatus) ->
      ok(false, "Response should have been successfully faked")
    complete: (xhr, textStatus) ->
      start()

  stop()
  $.fauxjax.removeFaux(id)

  $.fauxjax
    url: "faux-request"
    contentType: "text/plain"
    responseText: "default"

  $.ajax
    url: "faux-request"
    success: (data, textStatus, xhr) ->
      equal(data, "default", "Response from fake was not what was expected: #{data}")
    error: (xhr, textStatus) ->
      ok(false, "Response should have been successfully faked")
    complete: (xhr, textStatus) ->
      start()

test "Remove fauxjax definition by id when mutiple exist", ->
  id = $.fauxjax(
    type: "GET"
    url: "/faux-request/two"
    contentType: "text/plain"
    responseText: "test"
  )

  $.fauxjax(
    type: "GET"
    url: "/faux-request"
    contentType: "text/plain"
    responseText: "test"
  )

  equal(2, $.fauxjax.unfiredFauxHandlers().length)
  $.fauxjax.removeFaux(id)
  equal(1, $.fauxjax.unfiredFauxHandlers().length)
