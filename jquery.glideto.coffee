#  Project: jQuery glideTo
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
  filterPath = (string) ->
    string = "" + string
    string.replace(/^\//, "").replace(/(index|default).[a-zA-Z]{3,4}$/, "").replace /\/$/, ""

  # Create the defaults once
  pluginName = 'glideTo'

  defaults =
    scrollVertical: scrollableElement('html', 'body')
    scrollHorizontal: '#main'
    easing: 'easeInOutQuad'
    duration: 1000
    sectionSelector: 'section'
    screenSelector: 'article'

  class GlideTo
    constructor: (options) ->
      @options = $.extend {}, defaults, options

      @_defaults = defaults
      @_name = pluginName
      @scrollVertical = $(@options.scrollVertical)
      @scrollHorizontal = $(@options.scrollHorizontal)
      # locationPath = filterPath(window.location.pathname)

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
      @locationPath = filterPath(location.pathname)

  $.glideTo = (options) ->
    if !$('body').data("plugin_#{pluginName}")
      $('body').data("plugin_#{pluginName}", new GlideTo(options))

  $.fn.glide = ->
    @each ->
      $(this).click (event) ->
        event.preventDefault()
        glide = $('body').data("plugin_#{pluginName}")
        thisPath = filterPath(@pathname) or glide.locationPath

        if glide.locationPath is thisPath and (location.hostname is @hostname or not @hostname) and @hash.replace(/#/, "")
          if @hash
            glide.glideTo(@hash)

)(jQuery, window, document)