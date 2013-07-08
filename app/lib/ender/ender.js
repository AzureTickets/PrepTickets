/*!
  * =============================================================
  * Ender: open module JavaScript framework (https://ender.no.de)
  * Build: ender build reqwest jar
  * Packages: ender-js@0.4.5 reqwest@0.8.2 es5-basic@0.2.1 jar@0.3.4
  * =============================================================
  */

/*!
  * Ender: open module JavaScript framework (client-lib)
  * copyright Dustin Diaz & Jacob Thornton 2011-2012 (@ded @fat)
  * http://ender.jit.su
  * License MIT
  */
(function (context) {

  // a global object for node.js module compatiblity
  // ============================================

  context['global'] = context

  // Implements simple module system
  // losely based on CommonJS Modules spec v1.1.1
  // ============================================

  var modules = {}
    , old = context['$']
    , oldEnder = context['ender']
    , oldRequire = context['require']
    , oldProvide = context['provide']

  function require (identifier) {
    // modules can be required from ender's build system, or found on the window
    var module = modules['$' + identifier] || window[identifier]
    if (!module) throw new Error("Ender Error: Requested module '" + identifier + "' has not been defined.")
    return module
  }

  function provide (name, what) {
    return (modules['$' + name] = what)
  }

  context['provide'] = provide
  context['require'] = require

  function aug(o, o2) {
    for (var k in o2) k != 'noConflict' && k != '_VERSION' && (o[k] = o2[k])
    return o
  }

  /**
   * main Ender return object
   * @constructor
   * @param {Array|Node|string} s a CSS selector or DOM node(s)
   * @param {Array.|Node} r a root node(s)
   */
  function Ender(s, r) {
    var elements
      , i

    this.selector = s
    // string || node || nodelist || window
    if (typeof s == 'undefined') {
      elements = []
      this.selector = ''
    } else if (typeof s == 'string' || s.nodeName || (s.length && 'item' in s) || s == window) {
      elements = ender._select(s, r)
    } else {
      elements = isFinite(s.length) ? s : [s]
    }
    this.length = elements.length
    for (i = this.length; i--;) this[i] = elements[i]
  }

  /**
   * @param {function(el, i, inst)} fn
   * @param {Object} opt_scope
   * @returns {Ender}
   */
  Ender.prototype['forEach'] = function (fn, opt_scope) {
    var i, l
    // opt out of native forEach so we can intentionally call our own scope
    // defaulting to the current item and be able to return self
    for (i = 0, l = this.length; i < l; ++i) i in this && fn.call(opt_scope || this[i], this[i], i, this)
    // return self for chaining
    return this
  }

  Ender.prototype.$ = ender // handy reference to self

  // dev tools secret sauce
  Ender.prototype.splice = function () { throw new Error('Not implemented') }

  function ender(s, r) {
    return new Ender(s, r)
  }

  ender['_VERSION'] = '0.4.5'

  ender.fn = Ender.prototype // for easy compat to jQuery plugins

  ender.ender = function (o, chain) {
    aug(chain ? Ender.prototype : ender, o)
  }

  ender._select = function (s, r) {
    if (typeof s == 'string') return (r || document).querySelectorAll(s)
    if (s.nodeName) return [s]
    return s
  }


  // use callback to receive Ender's require & provide and remove them from global
  ender.noConflict = function (callback) {
    context['$'] = old
    if (callback) {
      context['provide'] = oldProvide
      context['require'] = oldRequire
      context['ender'] = oldEnder
      if (typeof callback == 'function') callback(require, provide, this)
    }
    return this
  }

  if (typeof module !== 'undefined' && module.exports) module.exports = ender
  // use subscript notation as extern for Closure compilation
  context['ender'] = context['$'] = ender

}(this));

(function () {

  var module = { exports: {} }, exports = module.exports;

  /*!
    * Reqwest! A general purpose XHR connection manager
    * (c) Dustin Diaz 2013
    * https://github.com/ded/reqwest
    * license MIT
    */
  !function (name, context, definition) {
    if (typeof module != 'undefined' && module.exports) module.exports = definition()
    else if (typeof define == 'function' && define.amd) define(definition)
    else context[name] = definition()
  }('reqwest', this, function () {

    var win = window
      , doc = document
      , twoHundo = /^20\d$/
      , byTag = 'getElementsByTagName'
      , readyState = 'readyState'
      , contentType = 'Content-Type'
      , requestedWith = 'X-Requested-With'
      , head = doc[byTag]('head')[0]
      , uniqid = 0
      , callbackPrefix = 'reqwest_' + (+new Date())
      , lastValue // data stored by the most recent JSONP callback
      , xmlHttpRequest = 'XMLHttpRequest'
      , noop = function () {}

      , isArray = typeof Array.isArray == 'function'
          ? Array.isArray
          : function (a) {
              return a instanceof Array
            }

      , defaultHeaders = {
            contentType: 'application/x-www-form-urlencoded'
          , requestedWith: xmlHttpRequest
          , accept: {
                '*':  'text/javascript, text/html, application/xml, text/xml, */*'
              , xml:  'application/xml, text/xml'
              , html: 'text/html'
              , text: 'text/plain'
              , json: 'application/json, text/javascript'
              , js:   'application/javascript, text/javascript'
            }
        }

      , xhr = win[xmlHttpRequest]
          ? function () {
              return new XMLHttpRequest()
            }
          : function () {
              return new ActiveXObject('Microsoft.XMLHTTP')
            }
      , globalSetupOptions = {
          dataFilter: function (data) {
            return data
          }
        }

    function handleReadyState(r, success, error) {
      return function () {
        // use _aborted to mitigate against IE err c00c023f
        // (can't read props on aborted request objects)
        if (r._aborted) return error(r.request)
        if (r.request && r.request[readyState] == 4) {
          r.request.onreadystatechange = noop
          if (twoHundo.test(r.request.status))
            success(r.request)
          else
            error(r.request)
        }
      }
    }

    function setHeaders(http, o) {
      var headers = o.headers || {}
        , h

      headers.Accept = headers.Accept
        || defaultHeaders.accept[o.type]
        || defaultHeaders.accept['*']

      // breaks cross-origin requests with legacy browsers
      if (!o.crossOrigin && !headers[requestedWith]) headers[requestedWith] = defaultHeaders.requestedWith
      if (!headers[contentType]) headers[contentType] = o.contentType || defaultHeaders.contentType
      for (h in headers)
        headers.hasOwnProperty(h) && http.setRequestHeader(h, headers[h])
    }

    function setCredentials(http, o) {
      if (typeof o.withCredentials !== 'undefined' && typeof http.withCredentials !== 'undefined') {
        http.withCredentials = !!o.withCredentials
      }
    }

    function generalCallback(data) {
      lastValue = data
    }

    function urlappend (url, s) {
      return url + (/\?/.test(url) ? '&' : '?') + s
    }

    function handleJsonp(o, fn, err, url) {
      var reqId = uniqid++
        , cbkey = o.jsonpCallback || 'callback' // the 'callback' key
        , cbval = o.jsonpCallbackName || reqwest.getcallbackPrefix(reqId)
        // , cbval = o.jsonpCallbackName || ('reqwest_' + reqId) // the 'callback' value
        , cbreg = new RegExp('((^|\\?|&)' + cbkey + ')=([^&]+)')
        , match = url.match(cbreg)
        , script = doc.createElement('script')
        , loaded = 0
        , isIE10 = navigator.userAgent.indexOf('MSIE 10.0') !== -1

      if (match) {
        if (match[3] === '?') {
          url = url.replace(cbreg, '$1=' + cbval) // wildcard callback func name
        } else {
          cbval = match[3] // provided callback func name
        }
      } else {
        url = urlappend(url, cbkey + '=' + cbval) // no callback details, add 'em
      }

      win[cbval] = generalCallback

      script.type = 'text/javascript'
      script.src = url
      script.async = true
      if (typeof script.onreadystatechange !== 'undefined' && !isIE10) {
        // need this for IE due to out-of-order onreadystatechange(), binding script
        // execution to an event listener gives us control over when the script
        // is executed. See http://jaubourg.net/2010/07/loading-script-as-onclick-handler-of.html
        //
        // if this hack is used in IE10 jsonp callback are never called
        script.event = 'onclick'
        script.htmlFor = script.id = '_reqwest_' + reqId
      }

      script.onload = script.onreadystatechange = function () {
        if ((script[readyState] && script[readyState] !== 'complete' && script[readyState] !== 'loaded') || loaded) {
          return false
        }
        script.onload = script.onreadystatechange = null
        script.onclick && script.onclick()
        // Call the user callback with the last value stored and clean up values and scripts.
        fn(lastValue)
        lastValue = undefined
        head.removeChild(script)
        loaded = 1
      }

      // Add the script to the DOM head
      head.appendChild(script)

      // Enable JSONP timeout
      return {
        abort: function () {
          script.onload = script.onreadystatechange = null
          err({}, 'Request is aborted: timeout', {})
          lastValue = undefined
          head.removeChild(script)
          loaded = 1
        }
      }
    }

    function getRequest(fn, err) {
      var o = this.o
        , method = (o.method || 'GET').toUpperCase()
        , url = typeof o === 'string' ? o : o.url
        // convert non-string objects to query-string form unless o.processData is false
        , data = (o.processData !== false && o.data && typeof o.data !== 'string')
          ? reqwest.toQueryString(o.data)
          : (o.data || null)
        , http

      // if we're working on a GET request and we have data then we should append
      // query string to end of URL and not post data
      if ((o.type == 'jsonp' || method == 'GET') && data) {
        url = urlappend(url, data)
        data = null
      }

      if (o.type == 'jsonp') return handleJsonp(o, fn, err, url)

      http = xhr()
      http.open(method, url, o.async === false ? false : true)
      setHeaders(http, o)
      setCredentials(http, o)
      http.onreadystatechange = handleReadyState(this, fn, err)
      o.before && o.before(http)
      http.send(data)
      return http
    }

    function Reqwest(o, fn) {
      this.o = o
      this.fn = fn

      init.apply(this, arguments)
    }

    function setType(url) {
      var m = url.match(/\.(json|jsonp|html|xml)(\?|$)/)
      return m ? m[1] : 'js'
    }

    function init(o, fn) {

      this.url = typeof o == 'string' ? o : o.url
      this.timeout = null

      // whether request has been fulfilled for purpose
      // of tracking the Promises
      this._fulfilled = false
      // success handlers
      this._fulfillmentHandlers = []
      // error handlers
      this._errorHandlers = []
      // complete (both success and fail) handlers
      this._completeHandlers = []
      this._erred = false
      this._responseArgs = {}

      var self = this
        , type = o.type || setType(this.url)

      fn = fn || function () {}

      if (o.timeout) {
        this.timeout = setTimeout(function () {
          self.abort()
        }, o.timeout)
      }

      if (o.success) {
        this._fulfillmentHandlers.push(function () {
          o.success.apply(o, arguments)
        })
      }

      if (o.error) {
        this._errorHandlers.push(function () {
          o.error.apply(o, arguments)
        })
      }

      if (o.complete) {
        this._completeHandlers.push(function () {
          o.complete.apply(o, arguments)
        })
      }

      function complete (resp) {
        o.timeout && clearTimeout(self.timeout)
        self.timeout = null
        while (self._completeHandlers.length > 0) {
          self._completeHandlers.shift()(resp)
        }
      }

      function success (resp) {
        // use global data filter on response text
        var filteredResponse = globalSetupOptions.dataFilter(resp.responseText, type)
          , r = resp.responseText = filteredResponse
        if (r) {
          switch (type) {
          case 'json':
            try {
              resp = win.JSON ? win.JSON.parse(r) : eval('(' + r + ')')
            } catch (err) {
              return error(resp, 'Could not parse JSON in response', err)
            }
            break
          case 'js':
            resp = eval(r)
            break
          case 'html':
            resp = r
            break
          case 'xml':
            resp = resp.responseXML
                && resp.responseXML.parseError // IE trololo
                && resp.responseXML.parseError.errorCode
                && resp.responseXML.parseError.reason
              ? null
              : resp.responseXML
            break
          }
        }

        self._responseArgs.resp = resp
        self._fulfilled = true
        fn(resp)
        while (self._fulfillmentHandlers.length > 0) {
          self._fulfillmentHandlers.shift()(resp)
        }

        complete(resp)
      }

      function error(resp, msg, t) {
        self._responseArgs.resp = resp
        self._responseArgs.msg = msg
        self._responseArgs.t = t
        self._erred = true
        while (self._errorHandlers.length > 0) {
          self._errorHandlers.shift()(resp, msg, t)
        }
        complete(resp)
      }

      this.request = getRequest.call(this, success, error)
    }

    Reqwest.prototype = {
      abort: function () {
        this._aborted = true
        this.request.abort()
      }

    , retry: function () {
        init.call(this, this.o, this.fn)
      }

      /**
       * Small deviation from the Promises A CommonJs specification
       * http://wiki.commonjs.org/wiki/Promises/A
       */

      /**
       * `then` will execute upon successful requests
       */
    , then: function (success, fail) {
        success = success || function () {}
        fail = fail || function () {}
        if (this._fulfilled) {
          success(this._responseArgs.resp)
        } else if (this._erred) {
          fail(this._responseArgs.resp, this._responseArgs.msg, this._responseArgs.t)
        } else {
          this._fulfillmentHandlers.push(success)
          this._errorHandlers.push(fail)
        }
        return this
      }

      /**
       * `always` will execute whether the request succeeds or fails
       */
    , always: function (fn) {
        if (this._fulfilled || this._erred) {
          fn(this._responseArgs.resp)
        } else {
          this._completeHandlers.push(fn)
        }
        return this
      }

      /**
       * `fail` will execute when the request fails
       */
    , fail: function (fn) {
        if (this._erred) {
          fn(this._responseArgs.resp, this._responseArgs.msg, this._responseArgs.t)
        } else {
          this._errorHandlers.push(fn)
        }
        return this
      }
    }

    function reqwest(o, fn) {
      return new Reqwest(o, fn)
    }

    // normalize newline variants according to spec -> CRLF
    function normalize(s) {
      return s ? s.replace(/\r?\n/g, '\r\n') : ''
    }

    function serial(el, cb) {
      var n = el.name
        , t = el.tagName.toLowerCase()
        , optCb = function (o) {
            // IE gives value="" even where there is no value attribute
            // 'specified' ref: http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-862529273
            if (o && !o.disabled)
              cb(n, normalize(o.attributes.value && o.attributes.value.specified ? o.value : o.text))
          }
        , ch, ra, val, i

      // don't serialize elements that are disabled or without a name
      if (el.disabled || !n) return

      switch (t) {
      case 'input':
        if (!/reset|button|image|file/i.test(el.type)) {
          ch = /checkbox/i.test(el.type)
          ra = /radio/i.test(el.type)
          val = el.value
          // WebKit gives us "" instead of "on" if a checkbox has no value, so correct it here
          ;(!(ch || ra) || el.checked) && cb(n, normalize(ch && val === '' ? 'on' : val))
        }
        break
      case 'textarea':
        cb(n, normalize(el.value))
        break
      case 'select':
        if (el.type.toLowerCase() === 'select-one') {
          optCb(el.selectedIndex >= 0 ? el.options[el.selectedIndex] : null)
        } else {
          for (i = 0; el.length && i < el.length; i++) {
            el.options[i].selected && optCb(el.options[i])
          }
        }
        break
      }
    }

    // collect up all form elements found from the passed argument elements all
    // the way down to child elements; pass a '<form>' or form fields.
    // called with 'this'=callback to use for serial() on each element
    function eachFormElement() {
      var cb = this
        , e, i
        , serializeSubtags = function (e, tags) {
            var i, j, fa
            for (i = 0; i < tags.length; i++) {
              fa = e[byTag](tags[i])
              for (j = 0; j < fa.length; j++) serial(fa[j], cb)
            }
          }

      for (i = 0; i < arguments.length; i++) {
        e = arguments[i]
        if (/input|select|textarea/i.test(e.tagName)) serial(e, cb)
        serializeSubtags(e, [ 'input', 'select', 'textarea' ])
      }
    }

    // standard query string style serialization
    function serializeQueryString() {
      return reqwest.toQueryString(reqwest.serializeArray.apply(null, arguments))
    }

    // { 'name': 'value', ... } style serialization
    function serializeHash() {
      var hash = {}
      eachFormElement.apply(function (name, value) {
        if (name in hash) {
          hash[name] && !isArray(hash[name]) && (hash[name] = [hash[name]])
          hash[name].push(value)
        } else hash[name] = value
      }, arguments)
      return hash
    }

    // [ { name: 'name', value: 'value' }, ... ] style serialization
    reqwest.serializeArray = function () {
      var arr = []
      eachFormElement.apply(function (name, value) {
        arr.push({name: name, value: value})
      }, arguments)
      return arr
    }

    reqwest.serialize = function () {
      if (arguments.length === 0) return ''
      var opt, fn
        , args = Array.prototype.slice.call(arguments, 0)

      opt = args.pop()
      opt && opt.nodeType && args.push(opt) && (opt = null)
      opt && (opt = opt.type)

      if (opt == 'map') fn = serializeHash
      else if (opt == 'array') fn = reqwest.serializeArray
      else fn = serializeQueryString

      return fn.apply(null, args)
    }

    reqwest.toQueryString = function (o, trad) {
      var prefix, i
        , traditional = trad || false
        , s = []
        , enc = encodeURIComponent
        , add = function (key, value) {
            // If value is a function, invoke it and return its value
            value = ('function' === typeof value) ? value() : (value == null ? '' : value)
            s[s.length] = enc(key) + '=' + enc(value)
          }
      // If an array was passed in, assume that it is an array of form elements.
      if (isArray(o)) {
        for (i = 0; o && i < o.length; i++) add(o[i].name, o[i].value)
      } else {
        // If traditional, encode the "old" way (the way 1.3.2 or older
        // did it), otherwise encode params recursively.
        for (prefix in o) {
          buildParams(prefix, o[prefix], traditional, add)
        }
      }

      // spaces should be + according to spec
      return s.join('&').replace(/%20/g, '+')
    }

    function buildParams(prefix, obj, traditional, add) {
      var name, i, v
        , rbracket = /\[\]$/

      if (isArray(obj)) {
        // Serialize array item.
        for (i = 0; obj && i < obj.length; i++) {
          v = obj[i]
          if (traditional || rbracket.test(prefix)) {
            // Treat each array item as a scalar.
            add(prefix, v)
          } else {
            buildParams(prefix + '[' + (typeof v === 'object' ? i : '') + ']', v, traditional, add)
          }
        }
      } else if (obj && obj.toString() === '[object Object]') {
        // Serialize object item.
        for (name in obj) {
          buildParams(prefix + '[' + name + ']', obj[name], traditional, add)
        }

      } else {
        // Serialize scalar item.
        add(prefix, obj)
      }
    }

    reqwest.getcallbackPrefix = function () {
      return callbackPrefix
    }

    // jQuery and Zepto compatibility, differences can be remapped here so you can call
    // .ajax.compat(options, callback)
    reqwest.compat = function (o, fn) {
      if (o) {
        o.type && (o.method = o.type) && delete o.type
        o.dataType && (o.type = o.dataType)
        o.jsonpCallback && (o.jsonpCallbackName = o.jsonpCallback) && delete o.jsonpCallback
        o.jsonp && (o.jsonpCallback = o.jsonp)
      }
      return new Reqwest(o, fn)
    }

    reqwest.ajaxSetup = function (options) {
      options = options || {}
      for (var k in options) {
        globalSetupOptions[k] = options[k]
      }
    }

    return reqwest
  });

  if (typeof provide == "function") provide("reqwest", module.exports);

  !function ($) {
    var r = require('reqwest')
      , integrate = function (method) {
          return function () {
            var args = Array.prototype.slice.call(arguments, 0)
              , i = (this && this.length) || 0
            while (i--) args.unshift(this[i])
            return r[method].apply(null, args)
          }
        }
      , s = integrate('serialize')
      , sa = integrate('serializeArray')

    $.ender({
        ajax: r
      , serialize: r.serialize
      , serializeArray: r.serializeArray
      , toQueryString: r.toQueryString
      , ajaxSetup: r.ajaxSetup
    })

    $.ender({
        serialize: s
      , serializeArray: sa
    }, true)
  }(ender);

}());

(function () {

  var module = { exports: {} }, exports = module.exports;

  var __hasProp = Object.prototype.hasOwnProperty;

  if (!Function.prototype.bind) {
    Function.prototype.bind = function(that) {
      var Bound, args, target;
      target = this;
      if (typeof target.apply !== "function" || typeof target.call !== "function") {
        return new TypeError();
      }
      args = Array.prototype.slice.call(arguments);
      Bound = (function() {

        function Bound() {
          var Type, self;
          if (this instanceof Bound) {
            self = new (Type = (function() {

              function Type() {}

              Type.prototype = target.prototype;

              return Type;

            })());
            target.apply(self, args.concat(Array.prototype.slice.call(arguments)));
            return self;
          } else {
            return target.call.apply(target, args.concat(Array.prototype.slice.call(arguments)));
          }
        }

        Bound.prototype.length = (typeof target === "function" ? Math.max(target.length - args.length, 0) : 0);

        return Bound;

      })();
      return Bound;
    };
  }

  if (!Array.isArray) {
    Array.isArray = function(obj) {
      return Object.prototype.toString.call(obj) === "[object Array]";
    };
  }

  if (!Array.prototype.forEach) {
    Array.prototype.forEach = function(fn, that) {
      var i, val, _len;
      for (i = 0, _len = this.length; i < _len; i++) {
        val = this[i];
        if (i in this) fn.call(that, val, i, this);
      }
    };
  }

  if (!Array.prototype.map) {
    Array.prototype.map = function(fn, that) {
      var i, val, _len, _results;
      _results = [];
      for (i = 0, _len = this.length; i < _len; i++) {
        val = this[i];
        if (i in this) _results.push(fn.call(that, val, i, this));
      }
      return _results;
    };
  }

  if (!Array.prototype.filter) {
    Array.prototype.filter = function(fn, that) {
      var i, val, _len, _results;
      _results = [];
      for (i = 0, _len = this.length; i < _len; i++) {
        val = this[i];
        if (i in this && fn.call(that, val, i, this)) _results.push(val);
      }
      return _results;
    };
  }

  if (!Array.prototype.some) {
    Array.prototype.some = function(fn, that) {
      var i, val, _len;
      for (i = 0, _len = this.length; i < _len; i++) {
        val = this[i];
        if (i in this) if (fn.call(that, val, i, this)) return true;
      }
      return false;
    };
  }

  if (!Array.prototype.every) {
    Array.prototype.every = function(fn, that) {
      var i, val, _len;
      for (i = 0, _len = this.length; i < _len; i++) {
        val = this[i];
        if (i in this) if (!fn.call(that, val, i, this)) return false;
      }
      return true;
    };
  }

  if (!Array.prototype.reduce) {
    Array.prototype.reduce = function(fn) {
      var i, result;
      i = 0;
      if (arguments.length > 1) {
        result = arguments[1];
      } else if (this.length) {
        result = this[i++];
      } else {
        throw new TypeError('Reduce of empty array with no initial value');
      }
      while (i < this.length) {
        if (i in this) result = fn.call(null, result, this[i], i, this);
        i++;
      }
      return result;
    };
  }

  if (!Array.prototype.reduceRight) {
    Array.prototype.reduceRight = function(fn) {
      var i, result;
      i = this.length - 1;
      if (arguments.length > 1) {
        result = arguments[1];
      } else if (this.length) {
        result = this[i--];
      } else {
        throw new TypeError('Reduce of empty array with no initial value');
      }
      while (i >= 0) {
        if (i in this) result = fn.call(null, result, this[i], i, this);
        i--;
      }
      return result;
    };
  }

  if (!Array.prototype.indexOf) {
    Array.prototype.indexOf = function(value) {
      var i, _ref;
      i = (_ref = arguments[1]) != null ? _ref : 0;
      if (i < 0) i += length;
      i = Math.max(i, 0);
      while (i < this.length) {
        if (i in this) if (this[i] === value) return i;
        i++;
      }
      return -1;
    };
  }

  if (!Array.prototype.lastIndexOf) {
    Array.prototype.lastIndexOf = function(value) {
      var i;
      i = arguments[1] || this.length;
      if (i < 0) i += length;
      i = Math.min(i, this.length - 1);
      while (i >= 0) {
        if (i in this) if (this[i] === value) return i;
        i--;
      }
      return -1;
    };
  }

  if (!Object.keys) {
    Object.keys = function(obj) {
      var key, _results;
      _results = [];
      for (key in obj) {
        if (!__hasProp.call(obj, key)) continue;
        _results.push(key);
      }
      return _results;
    };
  }

  if (!Date.now) {
    Date.now = function() {
      return new Date().getTime();
    };
  }

  if (!Date.prototype.toISOString) {
    Date.prototype.toISOString = function() {
      return ("" + (this.getUTCFullYear()) + "-" + (this.getUTCMonth() + 1) + "-" + (this.getUTCDate()) + "T") + ("" + (this.getUTCHours()) + ":" + (this.getUTCMinutes()) + ":" + (this.getUTCSeconds()) + "Z");
    };
  }

  if (!Date.prototype.toJSON) {
    Date.prototype.toJSON = function() {
      return this.toISOString();
    };
  }

  if (!String.prototype.trim) {
    String.prototype.trim = function() {
      return String(this).replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    };
  }

  if (typeof provide == "function") provide("es5-basic", module.exports);
  $.ender(module.exports);
}());

(function () {

  var module = { exports: {} }, exports = module.exports;

  // Generated by CoffeeScript 1.3.3
  var jar;

  jar = typeof exports !== "undefined" && exports !== null ? exports : (this['jar'] = {});

  jar.Cookie = (function() {

    function Cookie(name, value, options) {
      var date, _base;
      this.name = name;
      this.value = value;
      this.options = options;
      if (this.value === null) {
        this.value = '';
        this.options.expires = -(60 * 60 * 24);
      }
      if (this.options.expires) {
        if (typeof this.options.expires === 'number') {
          date = new Date();
          date.setTime(date.getTime() + (this.options.expires * 1000));
          this.options.expires = date;
        }
        if (this.options.expires instanceof Date) {
          this.options.expires = this.options.expires.toUTCString();
        }
      }
      (_base = this.options).path || (_base.path = '/');
    }

    Cookie.prototype.toString = function() {
      var domain, expires, path, secure;
      path = "; path=" + this.options.path;
      expires = (this.options.expires ? "; expires=" + this.options.expires : '');
      domain = (this.options.domain ? "; domain=" + this.options.domain : '');
      secure = (this.options.secure ? '; secure' : '');
      return [this.name, '=', this.value, expires, path, domain, secure].join('');
    };

    return Cookie;

  })();

  jar.Jar = (function() {

    function Jar() {}

    Jar.prototype.parse = function() {
      var cookie, m, _i, _len, _ref;
      this.cookies = {};
      _ref = this._getCookies().split(/;\s/g);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        cookie = _ref[_i];
        m = cookie.match(/([^=]+)=(.*)/);
        if (Array.isArray(m)) {
          this.cookies[m[1]] = m[2];
        }
      }
    };

    Jar.prototype.encode = function(value) {
      return encodeURIComponent(JSON.stringify(value));
    };

    Jar.prototype.decode = function(value) {
      return JSON.parse(decodeURIComponent(value));
    };

    Jar.prototype.get = function(name, options) {
      var value;
      if (options == null) {
        options = {};
      }
      value = this.cookies[name];
      if (!('raw' in options) || !options.raw) {
        try {
          value = this.decode(value);
        } catch (e) {
          return;
        }
      }
      return value;
    };

    Jar.prototype.set = function(name, value, options) {
      var cookie;
      if (options == null) {
        options = {};
      }
      if (!('raw' in options) || !options.raw) {
        value = this.encode(value);
      }
      cookie = new jar.Cookie(name, value, options);
      this._setCookie(cookie);
      this.cookies[name] = value;
    };

    return Jar;

  })();

  if (typeof process !== "undefined" && process !== null ? process.pid : void 0) {
    require('./node');
  }

  if (typeof provide == "function") provide("jar", module.exports);

  // Generated by CoffeeScript 1.3.3
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  (function($) {
    var jar;
    jar = require('jar');
    jar.Jar = (function(_super) {

      __extends(Jar, _super);

      function Jar() {
        return Jar.__super__.constructor.apply(this, arguments);
      }

      Jar.prototype._getCookies = function() {
        return document.cookie;
      };

      Jar.prototype._setCookie = function(cookie) {
        document.cookie = cookie.toString();
      };

      Jar.prototype.get = function() {
        this.parse();
        return Jar.__super__.get.apply(this, arguments);
      };

      Jar.prototype.set = function() {
        this.parse();
        return Jar.__super__.set.apply(this, arguments);
      };

      return Jar;

    })(jar.Jar);
    return $.ender({
      jar: new jar.Jar,
      cookie: function(name, value, options) {
        if (value != null) {
          return $.jar.set(name, value, options);
        } else {
          return $.jar.get(name);
        }
      }
    });
  })(ender);

}());