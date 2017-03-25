module "removeExisting fauxHandlers tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "removeExisting handlers clears out fauxHandlers array by method and url", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request/1"
  $.fauxjax.new
    request:
      url: "/faux-request/2",
      method: "GET",

  $.ajax
    method: "GET"
    url: "/faux-request/1"
    complete: ->
      $.fauxjax.removeExisting("/faux-request/2", "GET")
      handlersNotFired = $.fauxjax.unfired()
      assert.equal(handlersNotFired.length, 0, "There should be no more handlers")
      done()

test "removeExisting handlers will not clear existing fauxHandlers if method does not match", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request/1"
  $.fauxjax.new
    request:
      url: "/faux-request/2",
      method: "PUT",

  $.ajax
    method: "GET"
    url: "/faux-request/1"
    complete: ->
      $.fauxjax.removeExisting("/faux-request/2", "GET")
      handlersNotFired = $.fauxjax.unfired()
      assert.equal(handlersNotFired.length, 1, "There should still be a handler b/c method does not match mocked")
      done()

test "removeExisting handlers will not clear existing fauxHandlers if url does not match", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request/1"
  $.fauxjax.new
    request:
      url: "/faux-request/2",
      method: "GET",

  $.ajax
    method: "GET"
    url: "/faux-request/1"
    complete: ->
      $.fauxjax.removeExisting("/faux-request/3", "GET")
      handlersNotFired = $.fauxjax.unfired()
      assert.equal(handlersNotFired.length, 1, "There should still be a handler b/c url does not match mocked")
      done()
