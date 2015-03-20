module "Test Fauxjax clear options",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Remove fauxjax definition by id", (assert) ->
  done1 = assert.async()
  done2 = assert.async()

  id = $.fauxjax.new
    method: "GET"
    url: "faux-request"
    responseText: "test"

  $.ajax
    method: "GET"
    url: "faux-request"
    success: (data, textStatus, xhr) ->
      assert.equal(data, "test", "Response from fake was not what was expected")
    error: (xhr, textStatus) ->
      assert.ok(false, "Response should have been successfully faked")
    complete: (xhr, textStatus) ->
      done1()

  $.fauxjax.remove(id)

  $.fauxjax.new
    method: "GET"
    url: "faux-request"
    responseText: "default"

  $.ajax
    method: "GET"
    url: "faux-request"
    success: (data, textStatus, xhr) ->
      assert.equal(data, "default", "Response from fake was not what was expected: #{data}")
    error: (xhr, textStatus) ->
      assert.ok(false, "Response should have been successfully faked")
    complete: (xhr, textStatus) ->
      done2()

test "Remove fauxjax definition by id when mutiple exist", (assert) ->
  id = $.fauxjax.new(
    method: "GET"
    url: "/faux-request/two"
    contentType: "text/plain"
    responseText: "test"
  )

  $.fauxjax.new(
    method: "GET"
    url: "/faux-request"
    contentType: "text/plain"
    responseText: "test"
  )

  assert.equal(2, $.fauxjax.unfired().length)
  $.fauxjax.remove(id)
  assert.equal(1, $.fauxjax.unfired().length)
