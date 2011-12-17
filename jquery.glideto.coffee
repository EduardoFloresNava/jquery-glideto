#  Project: jQuery moveTo
#  Description: Allows local scrolling defining different x and y axis
#  Author: Jeduan Cornejo
#  License: MIT

# the semi-colon before function invocation is a safety net against concatenated
# scripts and/or other plugins which may not be closed properly.
``
(($, window, document) ->
  scrollableElement = (elements...) ->
    for el in elements
      $scrollElement = $(el)
      if $scrollElement.scrollTop() > 0
        return el
      else
        $scrollElement.scrollTop 1
        isScrollable = $scrollElement.scrollTop() > 0
        $scrollElement.scrollTop 0
        return el  if isScrollable
    []

  # Create the defaults once
  pluginName = 'glideTo'
  
  defaults =
    scrollVertical: scrollableElement('html', 'body')
    scrollHorizontal: '#main'
    easing: 'easeInOutQuad'
    duration: 1000
  
  class Plugin
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options

      @_defaults = defaults
      @_name = pluginName
      @scrollVertical = $(@options.scrollVertical)
      @scrollHorizontal = $(@options.scrollHorizontal)

      @init()

    glideUpTo: (position, callback = ->) ->
      @scrollVertical.stop().animate
        scrollTop: position
      , @options.duration, @options.easing, callback

    glideLeftTo: (position, callback = ->) ->
      @scrollHorizontal.stop().animate
        scrollLeft: "+=" + position
      , @options.duration, @options.easing, callback
    
    glideTo: (target) ->
      $target = $(target)
      offset = $target.position()
      offset.left = $target.offsetParent().position().left unless $target.offsetParent().is(@scrollHorizontal)

      if offset.left is 0
        @glideUpTo offset.top, ->
          location.hash = target

      else if offset.top is 0 and @scrollVertical.scrollTop() is 0
        @glideLeftTo offset.left, ->
          location.hash = target

      else
        delayLeft = (if (@scrollVertical.scrollTop() is 0) then 0 else 100)
        that = this

        @glideUpTo 0, ->
          setTimeout (->
            that.glideLeftTo offset.left, ->
              setTimeout (->
                if offset.top > 0
                  that.glideUpTo offset.top, ->
                    location.hash = target
                else
                  location.hash = target
              ), 100
          ), delayLeft

    init: ->
      @glideTo(@options.target) if @options.target
    

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.glideTo = (target, options) ->
    options = $.extend options, {target: target}
    new Plugin( this, options )
    
)(jQuery, window, document)