module "jQuery shorthand method tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "jQuery shorthand method for post is correctly faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "POST"
      url: "/faux-request"
      data: {empty: "data"}
    response:
      content: {foo: "bar"}

  $.post( "/faux-request", {empty: "data"}, (response) ->
    assert.equal("bar", response.foo)
  ).fail(->
    assert.ok(false, "Request should have been successfully faked")
  ).complete(->
    done()
  )

test "jQuery shorthand method for get is correctly faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"
    response:
      content: {foo: "bar"}

  $.get( "/faux-request", (response) ->
    assert.equal("bar", response.foo)
  ).fail(->
    assert.ok(false, "Request should have been successfully faked")
  ).complete(->
    done()
  )

test "jQuery shorthand method for getJSON is correctly faked", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"
    response:
      content: {foo: "bar"}

  $.getJSON( "/faux-request", (response) ->
    assert.equal("bar", response.foo)
  ).fail(->
    assert.ok(false, "Request should have been successfully faked")
  ).complete(->
    done()
  )
