module "Test Fauxjax clear options",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Remove fauxjax definition by id", ->
  id = $.fauxjax.new(
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
  $.fauxjax.remove(id)

  $.fauxjax.new
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
  id = $.fauxjax.new(
    type: "GET"
    url: "/faux-request/two"
    contentType: "text/plain"
    responseText: "test"
  )

  $.fauxjax.new(
    type: "GET"
    url: "/faux-request"
    contentType: "text/plain"
    responseText: "test"
  )

  equal(2, $.fauxjax.unfired().length)
  $.fauxjax.remove(id)
  equal(1, $.fauxjax.unfired().length)
