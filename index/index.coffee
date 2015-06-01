# TODO:
# - Make responsive
# - Cross-browser testing
# - Better performance
# - Planet should say stuff
# - Spaceship when clicking title
# - Better title
# - Rainbows and unicorns for Femke
# - More space stuff
# - More icon types
# - Content!!!!!!!

# == Animations ==
# - selectItemStart: move item to selected-item-container, give fixed position, .item-animated-select-start (keeps it in place), store scroll position
# - selectItemMiddle: give item .item-animated-select-middle (moves it to top)
# - selectItemEnd: remove .item-animated-select-middle (becomes absolutely positioned or so)

# - deselectItemStart: give item fixed position, .item-deselect-start
# - deselectItemMiddle: restore scroll position, move to position in menu
# - deselectItemEnd: move back to menu-item-container

# - moveMenuContainerLeftStart: give menu-container .menu-container-move-left, trim height
# - moveMenuContainerLeftEnd: hide completely, restore height, scroll up
# - moveMenuContainerRightStart: unhide menu-container, set .menu-container-move-left
# - moveMenuContainerRightMiddle: remove menu-container .menu-container-move-left
# - moveMenuContainerRightEnd: -

# - showContentStart: open iframe, fade in
# - showContentEnd: -

# - moveContentRightStart: gives content fixed position, deactivate scrolling of iframe
# - moveContentRightMiddle: give content-container .content-container-move-right
# - moveContentRightEnd: hide content completely, remove .content-container-move-right, close iframe

# - moveBackgroundLeftStart: gives background .background-animating, and translation
# - moveBackgroundLeftEnd: removes .background-animating
# - moveBackgroundRightStart: fixes scroll position
# - moveBackgroundRightMiddle: adds .background-animating, sets background position according to scroll position
# - moveBackgroundRightEnd: removes .background-animating

# (item click)                   (delay)                      (animation end)
# ----------> selectItemStart ------------> selectItemMiddle ---------------> selectItemEnd
#                 |
#                 | (immediately)                             (animation end)
#                 +--------------> moveMenuContainerLeftStart ---------------> moveMenuContainerLeftEnd
#                 |
#                 | (immediately)                          (animation end)
#                 +--------------> moveBackgroundLeftStart ---------------> moveBackgroundLeftEnd
#                 |
#                 |   (delay)                        (animation end)
#                 \--------------> showContentStart ----------------> showContentEnd

# (on item page)
# -----------> selectItemEnd
# -----------> moveMenuContainerLeftEnd           (animation end)
# --------------> showContentStart -----------------------------> showContentEnd

# (back click)                      (deferred)                                        (immediately)
# -------------> deselectItemStart -----------> deselectItemMiddle                        /---> deselectItemEnd
#                 |                               \-------> moveMenuContainerRightMiddle  |
#                 |                                  (delay)  +------------> moveMenuContainerRightEnd
#                 | (immediately)                             | (animation end)
#                 +-------------> moveMenuContainerRightStart |
#                 |                                           |
#                 | (immediately)                             |
#                 +----------------> moveContentRightStart    +--> moveContentRightMiddle --> moveContentRightEnd
#                 |                                           | (immediately)       (animation end)
#                 |                                           |
#                 | (immediately)                             | (immediately)         (animation end)
#                 \--------------> moveBackgroundRightStart   \--> moveBackgroundRightMiddle --> moveBackgroundRightEnd


setCss3 = ($element, name, value, addBrowserToValue) ->
  for browser in ['', '-ms-', '-moz-', '-webkit-', '-o-']
    if addBrowserToValue
      $element.css browser + name, browser + value
    else
      $element.css browser + name, value


window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame ||
                              window.webkitRequestAnimationFrame || window.msRequestAnimationFrame

log = ->
  # console.info arguments...

transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd'

window.selectedItemView = null

class BackgroundView extends Backbone.Marionette.ItemView
  _topOffset: 100
  template: -> ''

  onRender: ->
    @_height = 0
    @$window = $(window)
    _onScroll = _.throttle @_onScroll, 5
    @$window.on 'scroll', _onScroll
    _onScroll()

  _onScroll: =>
    return if @_stopUpdating
    @_updateScroll()
    @_updateHeight()

  _updateScroll: ->
    @_y = @_scrollTopToY()
    x = (if @_movedLeft then -200 else 0)
    setCss3 @$el, 'transform', "translate3d(#{x}px, #{-@_y}px, -1px)"

  _updateHeight: -> # TODO: only on resize / etc
    if @_y + @$window.height() >= @_height - @_topOffset - 100
      @_height = @_y + @$window.height() + @_topOffset + 500
      @$el.height @_height

  _scrollTopToY: ->
    scrollTop = if @_movedUp then 0 else @_scrollTop()
    Math.max(-@_topOffset, parseFloat((scrollTop / 4).toFixed(2)) + 0.005)

  _scrollTop: ->
    window.contentContainerView?.scrollTop() ? @$window.scrollTop()

  moveBackgroundLeftStart: =>
    log 'moveBackgroundLeftStart'
    @$el.off transitionEnd

    @_stopUpdating = false
    @_movedLeft = true
    @_movedUp = true
    @_onScroll()
    @$el.addClass 'background-animating'
    @$el.on transitionEnd, @moveBackgroundLeftEnd

  moveBackgroundLeftEnd: =>
    log 'moveBackgroundLeftEnd'
    @$el.off transitionEnd
    @_stopUpdating = false
    @_movedLeft = true
    @_movedUp = false
    @$el.removeClass 'background-animating'
    @_onScroll()

  moveBackgroundRightStart: =>
    log 'moveBackgroundRightStart'
    @$el.off transitionEnd

    @_onScroll()
    @_stopUpdating = true
    @_movedLeft = false
    @_movedUp = false

  moveBackgroundRightMiddle: =>
    log 'moveBackgroundRightMiddle'
    @$el.off transitionEnd

    @$el.addClass 'background-animating'
    @_stopUpdating = false
    @_movedLeft = false
    @_movedUp = false
    @_onScroll()
    @$el.on transitionEnd, @moveBackgroundRightEnd

  moveBackgroundRightEnd: =>
    log 'moveBackgroundRightEnd'
    @$el.off transitionEnd
    @$el.removeClass 'background-animating'
    @_stopUpdating = false
    @_movedLeft = false
    @_movedUp = false
    @_onScroll()


class ContentContainerView extends Backbone.Marionette.Layout
  template: => """
    <div class="js-iframe-region"></div>
  """

  regions:
    iframeRegion: '.js-iframe-region'

  showContentStart: (url) =>
    log 'showContentStart'
    @_reset()
    $(window).scrollTop 0
    @showIframe url, =>
      @$el.on transitionEnd, @showContentEnd
      @$el.addClass 'content-container-visible content-container-animated'

  showContentEnd: =>
    log 'showContentEnd'
    @_reset()
    @$el.addClass 'content-container-visible'
    $(window).scrollTop 0
    window.router.fixScrollPosition()

  moveContentRightStart: =>
    log 'moveContentRightStart'
    @_reset()
    @$el.addClass 'content-container-visible content-container-fixed'
    $(window).scrollTop 0
    @iframeRegion.currentView?.deactivate()

  moveContentRightMiddle: =>
    log 'moveContentRightMiddle'
    @$el.addClass 'content-container-move-right'
    @$el.on transitionEnd, @moveContentRightEnd

  moveContentRightEnd: =>
    log 'moveContentRightEnd'
    @_reset()
    @iframeRegion.close()

  _reset: ->
    @$el.off transitionEnd
    @$el.removeClass 'content-container-visible content-container-animated content-container-fixed content-container-move-right'

  showIframe: (url, onLoad) ->
    onLoadOnce = _.once(onLoad)
    setTimeout onLoadOnce, 500

    iframeView = new IframeView url: url
    @listenTo iframeView, 'onLoad', onLoadOnce
    @iframeRegion.show iframeView

  scrollTop: ->
    @iframeRegion.currentView?.scrollTop()


class MenuContainerView extends Backbone.Marionette.ItemView

  moveMenuContainerLeftStart: =>
    log 'moveMenuContainerLeftStart'
    @$el.off transitionEnd
    @$el.addClass 'menu-container-move-left menu-container-animated'
    @$el.height $(window).scrollTop() + $(window).height()
    @$el.on transitionEnd, @moveMenuContainerLeftEnd

  moveMenuContainerLeftEnd: (e) =>
    return unless !e? || e.target == @$el[0]

    log 'moveMenuContainerLeftEnd'
    @$el.off transitionEnd
    @$el.hide()
    @$el.removeClass 'menu-container-move-left menu-container-animated'
    @$el.height '101%'

  moveMenuContainerRightStart: =>
    log 'moveMenuContainerRightStart'
    @$el.off transitionEnd

    # show in place so the item can be animated to it
    @$el.show()
    @$el.css 'visibility', 'hidden'
    @$el.removeClass 'menu-container-move-left menu-container-animated'

  moveMenuContainerRightMiddle: =>
    log 'moveMenuContainerRightMiddle'
    @$el.off transitionEnd
    @$el.addClass 'menu-container-move-left'
    @$el.removeClass 'menu-container-animated'
    @$el.css 'visibility', 'visible'

    window.requestAnimationFrame =>
      # in this frame the styles are being applied, so wait another frame
      # to set new styles
      window.requestAnimationFrame =>
        @$el.addClass 'menu-container-animated'
        @$el.removeClass 'menu-container-move-left'
        @$el.on transitionEnd, @moveMenuContainerRightEnd
        contentContainerView.moveContentRightMiddle()
        backgroundView.moveBackgroundRightMiddle()

  moveMenuContainerRightEnd: (e) =>
    return unless e.target == @$el[0]

    log 'moveMenuContainerRightEnd'
    @$el.off transitionEnd
    @$el.removeClass 'menu-container-animated'
    window.selectedItemView.deselectItemEnd()
    window.router.fixScrollPosition()

  height: -> @$('.js-menu').height()


class ItemView extends Backbone.Marionette.ItemView

  initialize: ->
    @_viewHref = @$el.data('href') || @$el.attr('href')
    linkHref = @$el.attr('href')
    @$el.attr 'href', '#' + @$el.attr('id')

    innerLink = "<a href='#{linkHref}' target='_blank'>#{@$el.data('host')}</a>"
    innerTime = _.compact([innerLink, @$el.data('with'), @$el.data('time')]).join(', ')
    @$animatedEl = $("<div><a href='#' class='item-animated-back'><span class='icon-hand-left'></span> Back</a><div class='item-animated-inner'><div class='item-animated-inner-title'>#{@$el.html()}</div><div class='item-animated-inner-description'><div class='item-animated-inner-time'>#{innerTime}</div>#{@$el.data('description')}</div></div></div>")
    @$animatedEl.addClass @$el.attr('class')
    @$animatedEl.addClass 'item-animated'
    $('.js-item-animated-container').append @$animatedEl

  href: -> @_viewHref

  selectItemStart: =>
    log 'selectItemStart'

    window.selectedItemView?.deselectItemEnd()
    window.selectedItemView = this
    @lastScrollTop = $(window).scrollTop()

    @reset()
    offset = @$el.offset()
    @$animatedEl.css
      left: offset.left
      top: offset.top - $(window).scrollTop()
      right: $(window).width() - offset.left - @$el.outerWidth()
    @$animatedEl.addClass 'item-animated-select-start item-animated-active'
    @$el.addClass 'item-hidden'

    menuContainerView.moveMenuContainerLeftStart()
    backgroundView.moveBackgroundLeftStart()
    _.delay @selectItemMiddle, 300
    _.delay (=> contentContainerView.showContentStart @href()), 650

  selectItemMiddle: =>
    log 'selectItemMiddle'

    @reset()
    @$animatedEl.addClass 'item-animated-select-middle item-animated-active'
    @$el.addClass 'item-hidden'

    @$animatedEl.on transitionEnd, @selectItemEnd

  selectItemEnd: (e) =>
    return unless !e? || e.target == @$animatedEl[0]

    log 'selectItemEnd'
    window.selectedItemView?.deselectItemEnd()
    window.selectedItemView = this

    @reset()
    @$animatedEl.addClass 'item-animated-select-end item-animated-active'
    @$el.addClass 'item-hidden'

  deselectItemStart: =>
    log 'deselectItemStart'

    @reset()
    @$el.addClass 'item-hidden'
    @$animatedEl.addClass 'item-animated-deselect-start item-animated-active'

    backgroundView.moveBackgroundRightStart()
    menuContainerView.moveMenuContainerRightStart()
    contentContainerView.moveContentRightStart()
    window.requestAnimationFrame =>
      # in this frame the styles are being applied, so wait another frame
      # to set new styles
      window.requestAnimationFrame @deselectItemMiddle

  deselectItemMiddle: =>
    log 'deselectItemMiddle'
    @reset()
    @$el.addClass 'item-hidden'
    @$animatedEl.addClass 'item-animated-deselect-middle'
    # Stuff above explicitly before scroll top, as that rerenders in FF

    # This seems to fix a bug in Chrome where the scroll position stays 0, even when trying to
    # explicitly set the scrollTop to the correct value below
    $(window).scrollTop 1

    newScrollTop = @_restoreScrollTop @lastScrollTop
    $(window).scrollTop newScrollTop
    log 'restoring scroll position', $(window).scrollTop(), newScrollTop, @lastScrollTop

    offset = @$el.offset()
    @$animatedEl.css
      left: offset.left
      top: offset.top - $(window).scrollTop()
      right: $(window).width() - offset.left - @$el.outerWidth() - 0.5 # small offset to prevent text being hidden, especially when zoomed in

    _.delay menuContainerView.moveMenuContainerRightMiddle, 300

  deselectItemEnd: =>
    log 'deselectItemEnd'
    @reset()
    window.selectedItemView = null
    _.defer globalOnScroll

  reset: =>
    @$el.removeClass 'item-hidden'
    @$animatedEl.css left: '', top: '', right: ''
    @$animatedEl.removeClass 'item-animated-select-start item-animated-select-middle item-animated-select-end'
    @$animatedEl.removeClass 'item-animated-deselect-start item-animated-deselect-middle'
    @$animatedEl.removeClass 'item-animated-active'
    @$animatedEl.off transitionEnd

  _restoreScrollTop: (scrollTop) ->
    windowHeight = $(window).height()
    pageHeight = menuContainerView.height()
    offset = @$el.offset()

    unless scrollTop? && scrollTop+100 < offset.top < scrollTop+windowHeight-100
      scrollTop = offset.top + 36/2 - windowHeight/2

    if scrollTop >= pageHeight - windowHeight
      scrollTop = pageHeight - windowHeight

    Math.floor(scrollTop)


class IframeView extends Backbone.Marionette.ItemView

  template: -> ''

  onRender: ->
    log 'iframe onRender', @options.url
    @$el.html "<iframe class='content-iframe' scrolling='yes' frameborder='0' src='#{@options.url}'></iframe>"
    @_iframe().on 'load', => @onLoad()

  onLoad: ->
    log 'iframe onLoad', @options.url
    @_active = true
    @_setClass()
    @_bindScroll()
    @trigger 'onLoad'

  _iframe: ->
    @$('iframe')

  _setClass: ->
    doc = @_document()

    if doc
      $(doc.body.parentNode).addClass('jpp-iframe')
      $(doc.documentElement).find('html').addClass('jpp-iframe')

  _bindScroll: ->
    return unless @_document()?

    iframeWindow = @_iframe()[0].contentWindow
    $window = $(window)
    $(iframeWindow).on 'scroll', (-> $window.trigger('scroll')) if iframeWindow

  scrollTop: ->
    return null unless @_active

    @_document()?.body.scrollTop

  _document: ->
    try
      return @_iframe()[0].contentDocument ? @_iframe()[0].contentWindow.document
    catch e
      console.error e
      return null

  deactivate: -> @_active = false

class Router extends Backbone.Router
  routes:
    '': '_showIndex'
    ':page': '_showPage'

  initialize: ->
    @$window = $(window)
    @$window.on 'scroll', _.throttle @_onScroll, 5
    @_onScroll()
    @_onScroll()

  _onScroll: =>
    @_previousScrollTop = @_scrollTop
    @_scrollTop = window.pageYOffset
    log '@_scrollTop', @_scrollTop
    globalOnScroll()

  fixScrollPosition: ->
    @_previousScrollTop = @_scrollTop = window.pageYOffset

  _showIndex: ->
    @_restoreScrollTop() # prevent browser resetting of scrollTop
    @_index()

  _showPage: (page) ->
    unless $("a[name=#{page}]").length > 0 # allow scrolling to anchors
      @_restoreScrollTop() # prevent browser resetting of scrollTop
    @_page(page)

  _restoreScrollTop: ->
    if /(iPad|iPhone|iPod)/g.test(navigator.userAgent)
      # iOS seems to not scroll immediately...
      scrollTop = @_scrollTop
    else
      scrollTop = @_previousScrollTop

    @$window.scrollTop scrollTop
    window.requestAnimationFrame =>
      @$window.scrollTop scrollTop

  navigateToIndex: ->
    @navigate ''
    @_index()

  navigateToPage: (page) ->
    @navigate page
    @_page(page)

  _index: ->
    if @_loaded && selectedItemView?
      selectedItemView.deselectItemStart()
    @_showBodyContent()

  _page: (page) ->
    if itemViews[page]?
      if !@_loaded || selectedItemView?
        @_showFirstItemView itemViews[page]
      else
        itemViews[page].selectItemStart()
    else
      @_index()
    @_showBodyContent()
    pauseAllVimeoPlayers()

  _showFirstItemView: (itemView) ->
    itemView.selectItemEnd()
    menuContainerView.moveMenuContainerLeftEnd()
    contentContainerView.showContentStart itemView.href()
    backgroundView.moveBackgroundLeftEnd()

  _showBodyContent: ->
    @_loaded = true
    $('.body-loading').removeClass 'body-loading'


$ ->
  window.backgroundView = new BackgroundView(el: $('.js-background')).render()
  window.contentContainerView = new ContentContainerView(el: $('.js-content-container')).render()
  window.menuContainerView = new MenuContainerView(el: $('.js-menu-container'))

  window.itemViews = {}
  window.itemViews[$(el).attr('id')] = new ItemView(el: el) for el in $('.js-item')

  window.router = new Router
  Backbone.history.start()

  email = 'mailto:j' + '@' + 'npaulpos'
  email += '.ma'
  $('#email').attr 'href', email


#############


globalOnScroll = ->
  updateVimeoPlayers()

vimeoPlayers = []
$ ->
  $('.js-vimeo-player').each ->
    $iframe = $(this)
    player = $f(this)
    player.addEvent 'ready', ->
      vimeoPlayers.push $iframe: $iframe, player: player

      player.addEvent 'pause', ->
        $iframe.data 'playing', ''
        log 'vimeo paused', $iframe[0]

      player.addEvent 'play', ->
        $iframe.data 'playing', 'true'
        log 'vimeo playing', $iframe[0]

      updateVimeoPlayers()

updateVimeoPlayers = ->
  return if selectedItemView

  for vimeoPlayer in vimeoPlayers
    boundingRect = vimeoPlayer.$iframe[0].getBoundingClientRect()
    if boundingRect.bottom > 0 && boundingRect.top < window.innerHeight
      if vimeoPlayer.$iframe.data('playing') != 'true'
        vimeoPlayer.player.api 'play'
        log 'vimeo starting to play', vimeoPlayer.$iframe[0]
    else if vimeoPlayer.$iframe.data('playing') == 'true'
      vimeoPlayer.player.api 'pause'
      log 'vimeo starting to pause', vimeoPlayer.$iframe[0]

pauseAllVimeoPlayers = ->
  log 'pauseAllVimeoPlayers'
  for vimeoPlayer in vimeoPlayers
    if vimeoPlayer.$iframe.data('playing') == 'true'
      vimeoPlayer.player.api 'pause'
      log 'vimeo starting to pause', vimeoPlayer.$iframe[0]



############

# Keep in sync with CSS
imageHeight = 250
imageMargin = 0
numberOfImages = 17
imageAngle = 360 / numberOfImages
imageDistance = (imageHeight / 2 + imageMargin) / Math.tan(imageAngle / 360 * Math.PI);
lastRotateAngle = 0

makeBetweenMinus180And180 = (angle) -> ((angle+180+360*10000)%360)-180

updateCarouselOpacities = (selectedIndex) ->
  $('.carousel-inner img').each (index) ->
    $(this).css 'opacity', Math.cos((selectedIndex - index)*imageAngle/360*2*Math.PI)/2+0.6;

rotateCarouselTo = (selectedIndex) ->
  rotateAngle = (selectedIndex-1)*imageAngle
  rotateAngle = lastRotateAngle - makeBetweenMinus180And180(lastRotateAngle-rotateAngle)
  lastRotateAngle = rotateAngle
  setCss3 $('.carousel-inner'), 'transform', "translateZ(-#{imageDistance}px) rotateX(#{rotateAngle}deg)"

$ ->
  $('.carousel-inner img').each (index) ->
    angle = -(index-1)*imageAngle
    setCss3 $(this), 'transform', "rotateX(#{angle}deg) translateZ(#{imageDistance}px) translateX(-50%)"

  rotateCarouselTo 0
  updateCarouselOpacities 0
  _.defer -> setCss3 $('.carousel-inner'), 'transition', 'transform 1s', true

  $('[data-carousel-index]').each ->
    carouselIndex = $(this).data('carousel-index')
    $(this).on 'mouseenter', ->
      rotateCarouselTo carouselIndex
      updateCarouselOpacities carouselIndex

  $('.js-menu-planet').click ->
    clearTimeout(window.planetStartledTimeout) if window.planetStartledTimeout?

    if $('.js-menu-planet-container').hasClass 'menu-planet-container-startled'
      $('.js-menu-planet-container').addClass 'menu-planet-container-fallen'
      $('.js-menu-planet-subtext').addClass 'menu-planet-subtext-crooked'
    else
      $('.js-menu-planet-container').addClass 'menu-planet-container-startled'
      window.planetStartledTimeout = setTimeout (-> $('.js-menu-planet-container').removeClass 'menu-planet-container-startled'), 5000

  $('.js-menu-social-satellite-container').click ->
    clearTimeout(window.satelliteStartledTimeout) if window.satelliteStartledTimeout?
    unstartle = -> $('.js-menu-social-container').removeClass 'menu-social-container-startled menu-social-container-startled2'

    if $('.js-menu-social-container').hasClass 'menu-social-container-startled2'
      $('.js-menu-social-container').addClass 'menu-social-container-startled3'
    else if $('.js-menu-social-container').hasClass 'menu-social-container-startled'
      $('.js-menu-social-container').addClass 'menu-social-container-startled2'
      window.satelliteStartledTimeout = setTimeout unstartle, 5000
    else
      $('.js-menu-social-container').addClass 'menu-social-container-startled'
      window.satelliteStartledTimeout = setTimeout unstartle, 5000
