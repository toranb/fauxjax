module "Header Tests",
  setup: ->
    @defaultSettings = _.clone($.fauxjax.settings)
    $.fauxjax.settings.responseTime = 0
  teardown: ->
    $.fauxjax.clear()
    $.fauxjax.settings = @defaultSettings

asyncTest "Fauxjax request correctly returns html", ->
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    contentType: "text/html"
    data: {some: "post"}
    responseText: "<div>WINNING</div>"

  $.ajax
    type: "POST"
    url: "/faux-request"
    dataType: "html"
    data: {some: "post"}
    contentType: "text/html"
    success: (data, textStatus, xhr) ->
      equal(data, "<div>WINNING</div>", "Returned HTML does not match faked request")
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr, textStatus) ->
      equal(xhr.getResponseHeader("Content-Type"), "text/html", "Incorrect content type was returned from faked call")
      start()

asyncTest "Fauxjax request correctly returns json", ->
  $.fauxjax.new
    type: "POST"
    url: "/faux-request"
    contentType: "application/json"
    data: {filler: "text"}
    responseText: {foo: "bar", baz: {car: "far"}}

  $.ajax
    type: "POST"
    url: "/faux-request"
    dataType: "json"
    data: {filler: "text"}
    contentType: "application/json"
    success: (data, textStatus, xhr) ->
      ok(_.isEqual(data, {foo: "bar", baz: {car: "far"}}, "Returned json does not match"))
    error: (xhr, textStatus) ->
      ok(false, "Error was returned from a request that should have successfully been faked")
    complete: (xhr) ->
      equal(xhr.getResponseHeader("Content-Type"), "application/json", "Incorrect context type was returned from faked call")
      start()

asyncTest "Fauxjax request correctly returns text by default", ->
  $.fauxjax.new
    url: "/faux-request"
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
    headers: {"Something-Useful": "yes"}
    error: (xhr, textStatus) ->
      ok(false, "Request should have been successfully faked")
    success: (data, textStatus, xhr) ->
      equal(data, "done", "Request response didn't not match the fake")
    complete: (xhr, textStatus) ->
      equal(xhr.getResponseHeader("Something-Useful"), "yes", "Additional header is not present")
      start()

asyncTest "Fauxjax will not mock request if headers do not match", ->
  $.fauxjax.new
    type: "GET"
    url: "/fauxjax-request"
    responseText: {status: "success"}

  $.ajax
    type: "GET"
    url: "/fauxjax-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    error: (xhr, textStatus) ->
      ok(true, "We expect to get an error")
    success: (data, textStatus, xhr) ->
      ok(false, "Request should not have been mocked. Headers didn't match")
    complete: (xhr, textStatus) ->
      start()

asyncTest "Fauxjax will mock request when headers do match", ->
  $.fauxjax.new
    type: "GET"
    url: "/fauxjax-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    responseText: {status: "success"}

  $.ajax
    type: "GET"
    url: "/fauxjax-request"
    headers: {"Authorization": "Basic " + btoa("JarrodCTaylor:password1")}
    error: (xhr, textStatus) ->
      ok(false, "Request should have been mocked. Headers do match")
    success: (data, textStatus, xhr) ->
      ok(_.isEqual(data, '{"status":"success"}'), "Response text not a match received: #{data}")
    complete: (xhr, textStatus) ->
      start()
