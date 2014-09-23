module "Header Tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Fauxjax request correctly returns html", ->
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"
    contentType: "text/html"
    responseText: "<div>WINNING</div>"

  $.ajax
    url: "/faux-request"
    dataType: "html"
    success: (data, textStatus, xhr) ->
      equal(data, "<div>WINNING</div>", "Returned HTML does not match faked request")
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      equal(xhr.getResponseHeader("Content-Type"), "text/html", "Incorrect content type was returned from faked call")
      start()

asyncTest "Fauxjax request correctly returns json", ->
  $.fauxjax.new
    type: "GET"
    url: "/faux-request"
    contentType: "application/json"
    responseText: {foo: "bar", baz: {car: "far"}}

  $.ajax
    url: "/faux-request"
    dataType: "json"
    success: (data, textStatus, xhr) ->
      ok(_.isEqual(data, {foo: "bar", baz: {car: "far"}}, "Returned json does not match"))
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr) ->
      equal(xhr.getResponseHeader("Content-Type"), "application/json", "Incorrect context type was returned from faked call")
      start()

asyncTest "Fauxjax request correctly returns text", ->
  $.fauxjax.new
    url: "/faux-request"
    contentType: "text/plain"
    responseText: "just text"

  $.ajax
    url: "/faux-request"
    dataType: "text"
    success: (data, textStatus, xhr) ->
      ok(true, "Faux request should have have successful")
      ok(_.isEqual(data, "just text"))
    complete: (xhr, textStatus) ->
      equal xhr.getResponseHeader("Content-Type"), "text/plain", "Content type of text/plain"
      start()

asyncTest "Fauxjax can set additional response headers", ->
  $.fauxjax.new
    type: "GET"
    url: "/fauxjax-request"
    headers: {"Something-Useful": "yes"}
    responseText: "done"

  $.ajax
    type: "GET"
    url: "/fauxjax-request"
    error: (xhr, textStatus) ->
      ok(false, "Request should have been successfully faked")
    success: (data, textStatus, xhr) ->
      equal(data, "done", "Request response didn't not match the fake")
    complete: (xhr, textStatus) ->
      equal(xhr.getResponseHeader("Something-Useful"), "yes", "Additional header is not present")
      start()
