module "Core Fauxjax Functionality Tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Fauxjax default settings", ->
  ok(_.isEqual(@defaultSettings, $.fauxjax.settings))
  equal($.fauxjax.settings.status, 200)
  equal($.fauxjax.settings.statusText, "OK")
  equal($.fauxjax.settings.responseTime, 0)
  equal($.fauxjax.settings.isTimeout, false)
  equal($.fauxjax.settings.contentType, 'text/plain')
  equal($.fauxjax.settings.responseText, '')
  equal($.fauxjax.settings.headers['content-type'], 'text/plain')

asyncTest "Success callback should have access to xhr object", ->

  $.fauxjax.new
    type: "GET"
    url: "/faux-request"
    status: 200

  $.ajax
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      ok(xhr, "No xhr object passed to success")
      ok(xhr.status is 200, "xhr does not have the proper status code")
      start()
    error: (xhr, textStatus) ->
      ok(false, "Request should have been successfully faked")
