module "Test Faux Request Status Codes",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Fauxjax with status of 500 returns an error and status is 500", ->
  $.fauxjax
    url: "/faux-request"
    status:  500
    responseText: "Internal Server Error"

  $.ajax
    url: "/faux-request"
    error: (xhr, textStatus) ->
      ok(true, "Error should have been called since faux request had a status of 500")
      equal(xhr.responseText, "Internal Server Error")
    complete: (xhr, textStatus) ->
      equal(xhr.status, 500, "Fauxjax was created with an error of 500 actually returned: #{xhr.status}")
      start()

asyncTest "Fauxjax with status of 404 returns an error and status is 404", ->
  $.fauxjax
    url: "/faux-request"
    status:  404
    responseText: "Not Found"

  $.ajax
    url: "/faux-request"
    error: (xhr, textStatus) ->
      ok(true, "Error should have been called since faux request had a status of 404")
      equal(xhr.responseText, "Not Found")
    complete: (xhr, textStatus) ->
      equal(xhr.status, 404, "Fauxjax was created with an error of 404 actually returned: #{xhr.status}")
      start()

asyncTest "Fauxjax with status of 200 returns a success and status is 200", ->
  $.fauxjax
    url: "/faux-request"
    status:  200
    responseText: "That went well"

  $.ajax
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      ok(true, "Request should have been a success since faux request had a status of 200")
      equal(xhr.responseText, "That went well")
    complete: (xhr, textStatus) ->
      equal(xhr.status, 200, "Fauxjax was created as a success of 200 but actually returned: #{xhr.status}")
      start()
