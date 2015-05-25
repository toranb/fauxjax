module "fakedAjaxCalls array tests",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "fakedAjaxCalls public api function correctly returns expected array", (assert) ->
  done = assert.async()

  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request"

  $.ajax
    method: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->

  $.ajax
    method: "GET"
    url: "/faux-request"
    complete: (xhr, textStatus) ->
      fakedAjaxCalls = $.fauxjax.fakedAjaxCalls()
      assert.equal(fakedAjaxCalls.length, 2, "incorrect number of faked ajax calls in fakedAjaxCalls array")
      assert.equal(fakedAjaxCalls[0].method, "GET", "request has incorrect method")
      assert.equal(fakedAjaxCalls[0].url, "/faux-request", "real ajax call has incorrect url")
      assert.equal(fakedAjaxCalls[1].method, "GET", "request has incorrect method")
      assert.equal(fakedAjaxCalls[1].url, "/faux-request", "real ajax call has incorrect url")
      done()

