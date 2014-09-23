module "Connection Simulation Tests",
  setup: ->
    $.fauxjax
      url: "/faux-slower"
      responseTime: 150

    $.fauxjax
      url: "/faux-regular"
      responseTime: 50

    $.fauxjax
      url: "/faux-fase"
      responseTime: 0

  teardown: ->
    $.fauxjax.clear()

asyncTest "Async test", ->
  order = []

  $.ajax
    type: "GET"
    url: "/faux-regular"
    success: (data, textStatus, xhr) ->
      order.push("b")
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      ok(_.isEqual(order, ["a", "b"]))
      start()

  order.push("a")
  ok(_.isEqual(order, ["a"]))

test "Sync test", ->
  order = []

  $.ajax
    type: "GET"
    url: "/faux-regular"
    async: false
    success: (data, textStatus, xhr) ->
      order.push("b")
      ok(_.isEqual(order, ["b"]))
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")

  order.push("a")
  ok(_.isEqual(order, ["b", "a"]))

asyncTest "Fauxjax response time is correctly simulated", ->
  startTime = new Date()
  $.ajax
    type: "GET"
    url: "/faux-slower"
    complete: (xhr, textStatus) ->
      actualDelay = ((new Date()) - startTime)
      ok(actualDelay >= 150, "Fauxjax response time was set to 150 the acutal delay was: #{actualDelay}")
      start()

asyncTest "Fauxjax response time is correctly simulated fast", ->
  startTime = new Date()
  $.ajax
    type: "GET"
    url: "/faux-fast"
    complete: (xhr, textStatus) ->
      actualDelay = ((new Date()) - startTime)
      ok(actualDelay < 9, "Fauxjax response time was set to 0 the acutal delay was: #{actualDelay}")
      start()

asyncTest "Forcing timeout", ->
  $.fauxjax
    type: "GET"
    url: "/fauxjax-request"
    responseText: "done"
    isTimeout: true

  $.ajax
    url: "/fauxjax-request"
    success: (data, textStatus, xhr) ->
      ok(false, "isTimeout was set to true so reuqest should not have successfully returned")
    error: (xhr, textStatus) ->
      ok(true, "isTimeout was set to true so request should have returned an error")
    complete: (xhr, textStatus) ->
      start()
