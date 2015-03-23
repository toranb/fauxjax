module "Test Faux Response Status Codes",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Fauxjax with status of 500 returns an error and status is 500", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request"
    response:
      status: 500
      content: "Internal Server Error"

  $.ajax
    url: "/faux-request"
    error: (xhr, textStatus) ->
      assert.ok(true, "Error should have been called since faux had a response status of 500")
      assert.equal(xhr.responseText, "Internal Server Error")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.status, 500, "Fauxjax was created with an error of 500 actually returned: #{xhr.status}")
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax with status of 404 returns an error and status is 404", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request"
    response:
      status:  404
      content: "Not Found"

  $.ajax
    url: "/faux-request"
    error: (xhr, textStatus) ->
      assert.ok(true, "Error should have been called since faux had a response status of 404")
      assert.equal(xhr.responseText, "Not Found")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.status, 404, "Fauxjax was created with an error of 404 actually returned: #{xhr.status}")
      done()

  # As of Qunit 1.16.0 we cannot return a failing ajax request.
  # https://github.com/jquery/qunit/releases/tag/1.16.0
  return true

test "Fauxjax with status of 200 returns a success and status is 200", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      url: "/faux-request"
    response:
      status:  200
      content: "That went well"

  $.ajax
    url: "/faux-request"
    success: (data, textStatus, xhr) ->
      assert.ok(true, "Request should have been a success since faux had a response status of 200")
      assert.equal(xhr.responseText, "That went well")
    complete: (xhr, textStatus) ->
      assert.equal(xhr.status, 200, "Fauxjax was created as a success of 200 but actually returned: #{xhr.status}")
      done()

test "Fauxjax can return JSON data with an error", (assert) ->
  done = assert.async()
  $.fauxjax.new
    request:
      method: 'POST'
      url: '/faux-request'
      data: {'username': ''}
    response:
      status: 400
      content: {'username': ['This field is required']}

  $.ajax
    method: 'POST'
    url: '/faux-request'
    data: {'username': ''}
    success: ->
      assert.ok(false, "Returned a success response when it should have been an error")
    error: (xhr) ->
      assert.ok(_.isEqual(xhr.responseJSON, {'username': ['This field is required']}),
        "Expected JSON data in response to contain field error, but got: #{xhr.responseJSON}")
    complete: ->
      done()

  return true
