module "unfired array tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Get unfired handlers", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request/1"
  $.fauxjax.new
    request:
      url: "/faux-request/2"

  $.ajax
    method: "GET"
    url: "/faux-request/1"
    complete: ->
      handlersNotFired = $.fauxjax.unfired()
      assert.equal(handlersNotFired.length, 1, "There should be one handler that was not fired")
      assert.equal(handlersNotFired[0].request.url, "/faux-request/2", "Handler has unexpected url")
      done()
