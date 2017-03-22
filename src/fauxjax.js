(function($) {

    /* --------------------- Plugin Vars --------------------- */
    var _ajax          = $.ajax,
        fauxHandlers   = [],
        fakedAjaxCalls = [],
        unhandled      = [];

    /* ---------------- The Fauxjax Object ------------------- */
    $.fauxjax = {};

    /* -------------------- Public API ----------------------- */

    /**
     * Create new instance of faux request handler
     * @param {Object} settings The settings for the faux request
     * @returns {Int} Returns index faux request in handler array
     */
    $.fauxjax.new = function(settings) {
        fauxHandlers.push(settings);
        return fauxHandlers.length - 1;
    };

    /**
     * Default settings for fauxjax requests
     */
    $.fauxjax.settings = {
        status:        200,
        statusText:    'OK',
        responseTime:  0,
        isTimeout:     false,
        content:  '',
        contentType: 'application/x-www-form-urlencoded',
        strictMatching: true,
        debug: false,
        headers:       {}
    };

    /**
     * Clear all fauxjax arrays
     * @param {None}
     * @returns {undefined}
     */
    $.fauxjax.clear = function() {
        fauxHandlers   = [];
        fakedAjaxCalls = [];
        unhandled      = [];
    };

    /**
     * Remove faux handler from handlers array
     * @param {Integer} index The index of the faux handler to be removed
     * @returns {undefined}
     */
    $.fauxjax.remove = function(index) {
      fauxHandlers[index] = null;
    };

    /**
     * Gets an array containing all faux requests that have not been fired.
     * Useful is test teardown to check for unneeded mocking.
     * @param {None}
     * @returns {Array} Returns an array of faux requests that have not been fired
     */
    $.fauxjax.unfired = function() {
        var results = [];
        for (var i=0, len=fauxHandlers.length; i<len; i++) {
            var handler = fauxHandlers[i];
            if (handler !== null && !handler.fired) {
                results.push(handler);
            }
        }
        return results;
    };

    /**
     * Gets an array containing all real ajax requests.
     * Useful in test teardown to check for requests that need to be mocked.
     * @param {None}
     * @returns {Array} Returns an array of real ajax requests that have been fired
     */
    $.fauxjax.unhandled = function() {
        return unhandled;
    };

    /**
     * Gets an array containing all ajax requests that have been faked.
     * @param {None}
     * @returns {Array} Returns an array of all faked ajax requests
     */
    $.fauxjax.fakedAjaxCalls = function() {
        return fakedAjaxCalls;
    };

    /* -------------------- Internal Plugin API ----------------------- */
    $.extend({
        ajax: interceptAjax
    });

    /**
     * Called when shouldMockRequest returns false. If debug is set to true then log
     * debugging information
     * @param {String} url A string representing the requested url
     * @param {Sting} mismatchedProperty A string designating the property
     *                                   that caused the request to not be matched
     * @returns {undefined}
     */
    function debugInfo(mockVerb, realVerb, mockContentType, realContentType, mockData, realData, mockHeaders, realHeaders, mockUrl, realUrl) {
      if ($.fauxjax.settings.debug) {
        console.log('===== Fauxjax Debug Info =====');
        console.log('*Real Request*');
        console.log('    URL:         ' + realUrl);
        console.log('    Type:        ' + realVerb);
        console.log('    contentType: ' + realContentType);
        console.log('    Headers:     ' + _.toPairs(realHeaders));
        console.log('    Data:        ' + JSON.stringify(realData));
        console.log('*Mock Request*');
        console.log('    URL:         ' + mockUrl);
        console.log('    Type:        ' + mockVerb);
        console.log('    contentType: ' + mockContentType);
        console.log('    Headers:     ' + _.toPairs(mockHeaders));
        console.log('    Data:        ' + JSON.stringify(mockData));
      }
    }

    /**
     * Currently fauxjax expects that contentType will be either `x-www-form-urlencoded` or `json`
     * If it is not one we return the other.
     * @param {Object} handler The request handler for either the real request or the fake
     * @returns {String} Returns the contentType
     */
    function parseContentType(handler) {
      if (_.includes(handler.contentType, 'json')) { return 'application/json'; }
      return 'application/x-www-form-urlencoded';
    }

    /**
     * Currently fauxjax expects that contentType will be either `x-www-form-urlencoded` or `json`
     * Given this assumption we will have data that is either text, objects or a stringified object
     * based on the specified `contentType` pase the data to allow comparison in the `shouldMockRequest`
     * function.
     * @param {String|Object} data The data provided with the request
     * @param {String} contentType The contentType for the request
     * @returns {String|Object}    The parsed data to be compared for a match
     */
    function parseData(data, contentType) {
      if (_.includes(['application/vnd.api+json', 'application/json'], contentType) && !_.isObject(data)) { return JSON.parse(data); }
      return data;
    }

    /**
     * Compares a mockHandler and a real Ajax request and determines if the real request should be mocked.
     * @param {Object} mockHandler A fauxjax settings object
     * @param {Object} realRequestContext The real context of the actual Ajax request
     * @returns {Boolean} Returns true if the real request should be mocked false otherwise
     */
    function shouldMockRequest(mockHandler, realRequestContext) {
        if (mockHandler) {
           var mockVerb        = mockHandler.request.method || mockHandler.request.type;
           var realVerb        = realRequestContext.method || realRequestContext.type;
           var realContentType = parseContentType(realRequestContext);
           var mockContentType = parseContentType(mockHandler.request);
           var mockRequest     = mockHandler.request;
           var mockData        = parseData(mockHandler.request.data, mockContentType);
           var realData        = parseData(realRequestContext.data, realContentType);
           var urlRegexMatch   = _.isRegExp(mockRequest.url) && mockRequest.url.test(realRequestContext.url);
           if (!_.isEqual(mockRequest.url, realRequestContext.url) && !urlRegexMatch) { return false; }
           if (mockVerb && mockVerb.toLowerCase() !== realVerb.toLowerCase())         { return false; }
           if (!_.isEqual(realContentType, mockContentType))                          {
               if ($.fauxjax.settings.strictMatching || mockData && !realData)        {
                 debugInfo(mockVerb, realVerb, mockContentType, realContentType, mockData, realData, mockRequest.headers, realRequestContext.headers, mockRequest.url, realRequestContext.url);
                 return false;
               }
           }
           if (_.some(_.compact([mockData, realData])) && !_.isEqual(mockData, realData)) {
               if ($.fauxjax.settings.strictMatching || mockData && !realData) {
                 debugInfo(mockVerb, realVerb, mockContentType, realContentType, mockData, realData, mockRequest.headers, realRequestContext.headers, mockRequest.url, realRequestContext.url);
                 return false;
               }
           }
           if (!_.isEqual(mockRequest.headers, realRequestContext.headers) && $.fauxjax.settings.strictMatching) {
               debugInfo(mockVerb, realVerb, mockContentType, realContentType, mockData, realData, mockRequest.headers, realRequestContext.headers, mockRequest.url, realRequestContext.url);
               return false;
           }
           return true;
        } else {
          return false;
        }
    }

    /**
     * Properly format the faux request's content to be sent in the faux xhr
     * @param {Object|String} content The value of `content` in the mock request
     * @returns {String} Returns a string version of the `content`
     */
    function formatResponseText(content) {
        if (_.isObject(content)) {
            return JSON.stringify(content);
        }
        return content;
    }

    /**
     * Determine the response content-type based on the value of content
     * @param {Object|String} content The value of `content` in the mock request
     * @returns {String} Returns a string of the contentType
     */
    function getResponseContentType(content) {
        if (_.isObject(content)) {
            return 'json';
        }
        return 'text';
    }

    /**
     * The send operation of the faux xhr object
     * @param {Object} mockRequestContext The context of the faux request
     * @param {Object} realRequestContext The context of the real Ajax request
     * @returns {undefined}
     */
    function _xhrSend(mockRequestContext, realRequestContext) {
        var process = _.bind(function() {
                                  this.status = mockRequestContext.isTimeout ? -1 : mockRequestContext.status;
                                  this.statusText = mockRequestContext.statusText;
                                  this.responseText = formatResponseText(mockRequestContext.content);
                                  this.onload.call(this);
                             }, this);
        return realRequestContext.async ? setTimeout(process, mockRequestContext.responseTime) : process();
    }

    /**
     * Build the string used for response headers in the faux xhr object
     * @param {Object} mockRequestContext
     * @returns {Sting} Returns response headers
     */
    function buildResponseHeaders(mockRequestContext) {
        var headers = '';
        $.each(mockRequestContext.headers, function(k, v) {
            headers += k + ': ' + v + '\n';
        });
        return headers;
    }

    /**
     * Build a faux xhr object that can be used in the faux ajax response
     * @param {Object} mockHandler
     * @param {Object} realRequestContext
     * @returns {Object} Returns a faux xhr object
     */
    function fauxXhr(mockHandler, realRequestContext) {
        deepCloneSettings = _.clone($.fauxjax.settings, true);
        mockRequestContext = _.assign({}, deepCloneSettings, mockHandler.response);
        mockRequestContext.headers['content-type'] = getResponseContentType(mockRequestContext.content);
        realRequestContext.headers = {};
        return {
            status: mockRequestContext.status,
            statusText: mockRequestContext.statusText,
            open: function() { },
            send: function() {
                mockHandler.fired = true;
                _xhrSend.call(this, mockRequestContext, realRequestContext);
            },
            setRequestHeader: function(header, value) {
                realRequestContext.headers[header] = value;
            },
            getAllResponseHeaders: function() {
                return buildResponseHeaders(mockRequestContext);
            }
        };
    }

    /**
     * The actual call to the jQuery ajax method
     * @param {Object} mockHandler
     * @param {Object} realRequestContext
     * @param {Object} realRequestSettings
     * @returns {Object} Returns the actual jQuery ajax request object that was
     *                   created with the fauxXhr method
     */
    function makeFauxAjaxCall(mockHandler, realRequestContext, realRequestSettings) {
        fauxRequest = _ajax.call($, _.assign({}, realRequestSettings, {
          xhr: function() {return fauxXhr(mockHandler, realRequestContext);}
        }));
        return fauxRequest;
    }

    /**
     * The entry point of the plugin. This intercepts calls to jQuery's ajax method
     * @param {Object} realRequestSettings The real request settings from the actual ajax call
     * @returns {Object} Returns a jQuery ajax request object, either real or faux
     */
    function interceptAjax(realRequestSettings) {
        var realRequestContext = _.assign({}, $.ajaxSettings, realRequestSettings);
        for(var k = 0; k < fauxHandlers.length; k++) {
            if (shouldMockRequest(fauxHandlers[k], realRequestContext)) {
              fakedAjaxCalls.push(realRequestContext);
              fauxRequest = makeFauxAjaxCall(fauxHandlers[k], realRequestContext, realRequestSettings);
              return fauxRequest;
            }
        }
        unhandled.push(realRequestSettings);
        return _ajax.apply($, [realRequestSettings]);
    }

})(jQuery);
