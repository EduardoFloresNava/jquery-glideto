(function() {

  ;

  var __slice = Array.prototype.slice;

  (function($, window, document) {
    var Plugin, defaults, pluginName, scrollableElement;
    scrollableElement = function() {
      var $scrollElement, el, elements, isScrollable, _i, _len;
      elements = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (_i = 0, _len = elements.length; _i < _len; _i++) {
        el = elements[_i];
        $scrollElement = $(el);
        if ($scrollElement.scrollTop() > 0) {
          return el;
        } else {
          $scrollElement.scrollTop(1);
          isScrollable = $scrollElement.scrollTop() > 0;
          $scrollElement.scrollTop(0);
          if (isScrollable) return el;
        }
      }
      return [];
    };
    pluginName = 'glideTo';
    defaults = {
      scrollVertical: scrollableElement('html', 'body'),
      scrollHorizontal: '#main',
      easing: 'easeInOutQuad',
      duration: 1000
    };
    Plugin = (function() {

      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = pluginName;
        this.scrollVertical = $(this.options.scrollVertical);
        this.scrollHorizontal = $(this.options.scrollHorizontal);
        this.init();
      }

      Plugin.prototype.glideUpTo = function(position, callback) {
        if (callback == null) callback = function() {};
        return this.scrollVertical.stop().animate({
          scrollTop: position
        }, this.options.duration, this.options.easing, callback);
      };

      Plugin.prototype.glideLeftTo = function(position, callback) {
        if (callback == null) callback = function() {};
        return this.scrollHorizontal.stop().animate({
          scrollLeft: "+=" + position
        }, this.options.duration, this.options.easing, callback);
      };

      Plugin.prototype.glideTo = function(target) {
        var $target, delayLeft, offset, that;
        $target = $(target);
        offset = $target.position();
        if (!$target.offsetParent().is(this.scrollHorizontal)) {
          offset.left = $target.offsetParent().position().left;
        }
        if (offset.left === 0) {
          return this.glideUpTo(offset.top, function() {
            return location.hash = target;
          });
        } else if (offset.top === 0 && this.scrollVertical.scrollTop() === 0) {
          return this.glideLeftTo(offset.left, function() {
            return location.hash = target;
          });
        } else {
          delayLeft = (this.scrollVertical.scrollTop() === 0 ? 0 : 100);
          that = this;
          return this.glideUpTo(0, function() {
            return setTimeout((function() {
              return that.glideLeftTo(offset.left, function() {
                return setTimeout((function() {
                  if (offset.top > 0) {
                    return that.glideUpTo(offset.top, function() {
                      return location.hash = target;
                    });
                  } else {
                    return location.hash = target;
                  }
                }), 100);
              });
            }), delayLeft);
          });
        }
      };

      Plugin.prototype.init = function() {
        if (this.options.target) return this.glideTo(this.options.target);
      };

      return Plugin;

    })();
    return $.glideTo = function(target, options) {
      options = $.extend(options, {
        target: target
      });
      return new Plugin(this, options);
    };
  })(jQuery, window, document);

}).call(this);
