module "Promises Tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Faked calls have access to the done promise callback", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    responseText: "Told you I would come through"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).done (data, textStatus, jqXHR) ->
    assert.equal(data, "Told you I would come through")
    done()

test "Faked calls have access to the then promise callback", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    responseText: "Then do what you like"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).then (data, statusText, xhr) ->
    assert.equal(data, "Then do what you like")
    done()

test "Faked calls have access to the fail promise callback", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    status: 404
    statusText: "Request failed"
    isTimeout: true

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).fail (jqXHR, textStatus, errorThrown) ->
    assert.equal(errorThrown, "Request failed")
    done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Faked calls have access to the always promise callback", (assert) ->
  done = assert.async()
  $.fauxjax.new
    type: "GET"
    url: "http://faux-request"
    isTimeout: true
    responseText: "Old faithful"

  $.ajax(
    type: "GET"
    url: "http://faux-request"
  ).always (jqXHR, textStatus, errorThrown) ->
    assert.equal(jqXHR.responseText, "Old faithful")
    done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true
