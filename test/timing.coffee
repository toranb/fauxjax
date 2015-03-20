module "Connection Simulation Tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)

    $.fauxjax.new
      url: "/faux-regular"
      responseTime: 50

  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Async test", (assert) ->
  done = assert.async()
  order = []

  $.ajax
    method: "GET"
    url: "/faux-regular"
    success: (data, textStatus, xhr) ->
      order.push("b")
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      assert.ok(_.isEqual(order, ["a", "b"]))
      done()

  order.push("a")
  assert.ok(_.isEqual(order, ["a"]))

test "Sync test", (assert) ->
  order = []

  $.ajax
    method: "GET"
    url: "/faux-regular"
    async: false
    success: (data, textStatus, xhr) ->
      order.push("b")
      assert.ok(_.isEqual(order, ["b"]))
    error: (xhr, textStatus) ->
      assert.ok(false, "Error was returned from a request that should have successfully been faked")

  order.push("a")
  assert.ok(_.isEqual(order, ["b", "a"]))

test "Fauxjax response time is correctly simulated", (assert) ->
  done = assert.async()

  $.fauxjax.new
    url: "/faux-slower"
    responseTime: 150

  startTime = new Date()
  $.ajax
    method: "GET"
    url: "/faux-slower"
    complete: (xhr, textStatus) ->
      actualDelay = ((new Date()) - startTime)
      assert.ok(actualDelay >= 150, "Fauxjax response time was set to 150 the acutal delay was: #{actualDelay}")
      done()

test "Fauxjax response time is correctly simulated fast", (assert) ->
  done = assert.async()
  $.fauxjax.new
    url: "/faux-fast"
    responseTime: 0

  startTime = new Date()
  $.ajax
    method: "GET"
    url: "/faux-fast"
    complete: (xhr, textStatus) ->
      actualDelay = ((new Date()) - startTime)
      assert.ok(actualDelay < 40, "Fauxjax response time was set to 0 the acutal delay was: #{actualDelay}")
      done()

test "Forcing timeout", (assert) ->
  done = assert.async()
  $.fauxjax.new
    method: "GET"
    url: "/fauxjax-request"
    responseText: "done"
    isTimeout: true

  $.ajax
    method: "GET"
    url: "/fauxjax-request"
    success: (data, textStatus, xhr) ->
      assert.ok(false, "isTimeout was set to true so reuqest should not have successfully returned")
    error: (xhr, textStatus) ->
      assert.ok(true, "isTimeout was set to true so request should have returned an error")
    complete: (xhr, textStatus) ->
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true
