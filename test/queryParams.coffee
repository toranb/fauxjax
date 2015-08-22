module "Test Query Parameters In Url",
  beforeEach: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  afterEach: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

test "Fauxjax correctly fakes a url that uses query params", (assert) ->
  done = assert.async()
  expect(0)

  $.fauxjax.new
    request:
      method: "GET"
      url: "/faux-request/?params=im-a-query"
    response:
      content: {foo: "bar"}

  $.ajax
    method: "GET"
    url: "/faux-request/?params=im-a-query"
    error: (xhr, textStatus) ->
      assert.ok(false, "Urls match. Request should have successfully been faked")
    complete: (xhr, textStatus) ->
      done()
