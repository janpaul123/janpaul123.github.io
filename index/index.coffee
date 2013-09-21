# TODO:
# - Make responsive
# - Cross-browser testing
# - Better performance
# - Only activate group headers when moving over items
# - Planet should say stuff
# - Planet should fall down when clicked
# - Spaceship when clicking title
# - Better title
# - Rainbows and unicorns for Femke
# - More space stuff
# - More icon types
# - Content!!!!!!!

# == Animations ==
# - selectItemStart: move item to selected-item-container, give fixed position, .item-select-start (keeps it in place), store scroll position
# - selectItemMiddle: give item .item-select-middle (moves it to top)
# - selectItemEnd: remove .item-select-middle (becomes absolutely positioned or so)

# - deselectItemStart: give item fixed position, .item-deselect-start
# - deselectItemMiddle: restore scroll position, move to position in menu
# - deselectItemEnd: move back to menu-item-container

# - moveMenuContainerLeftStart: give menu-container .menu-container-move-left, trim height
# - moveMenuContainerLeftEnd: hide completely, restore height, scroll up
# - moveMenuContainerRightStart: unhide menu-container, set .menu-container-move-left
# - moveMenuContainerRightMiddle: remove menu-container .menu-container-move-left
# - moveMenuContainerRightEnd: -

# - showContentStart: attach content to content-container, fade in / slide in (?)
# - showContentEnd: -

# - moveContentRightStart: gives content fixed position based on current scroll position, trims height
# - moveContentRightMiddle: give content-container .content-container-move-right
# - moveContentRightEnd: hide content completely, remove .content-container-move-right, restores height

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

log = ->
  # console.info arguments...

transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd'

window.selectedItemView = null #####

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
    scrollTop = if @_movedUp then 0 else @$window.scrollTop()
    Math.max(-@_topOffset, parseFloat((scrollTop / 4).toFixed(2)) + 0.005)

  moveBackgroundLeftStart: =>
    log 'moveBackgroundLeftStart'
    @$el.off transitionEnd

    @_stopUpdating = false
    @_movedLeft = true
    @_movedUp = true
    @_updateScroll()
    @$el.addClass 'background-animating'
    @$el.on transitionEnd, @moveBackgroundLeftEnd

  moveBackgroundLeftEnd: =>
    log 'moveBackgroundLeftEnd'
    @$el.off transitionEnd
    @_stopUpdating = false
    @_movedLeft = true
    @_movedUp = false
    @$el.removeClass 'background-animating'
    @_updateScroll()

  moveBackgroundRightStart: =>
    log 'moveBackgroundRightStart'
    @$el.off transitionEnd

    @_updateScroll()
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
    @_updateScroll()
    @$el.on transitionEnd, @moveBackgroundRightEnd

  moveBackgroundRightEnd: =>
    log 'moveBackgroundRightEnd'
    @$el.off transitionEnd
    @$el.removeClass 'background-animating'
    @_stopUpdating = false
    @_movedLeft = false
    @_movedUp = false
    @_updateScroll()


class ContentContainerView extends Backbone.Marionette.ItemView
  template: => """
    <div class="content js-content-region"></div>
  """

  ui:
    contentRegion: '.js-content-region'

  initialize: ->
    @iframeViews = {}

  showContentStart: (url) =>
    log 'showContentStart'
    @_reset()
    @showIframe url
    @$el.on transitionEnd, @showContentEnd
    @$el.addClass 'content-container-visible content-container-animated'
    $(window).scrollTop 0

  showContentEnd: =>
    log 'showContentEnd'
    @_reset()
    @$el.addClass 'content-container-visible'
    $(window).scrollTop 0
    window.router.fixScrollPosition()

  moveContentRightStart: =>
    log 'moveContentRightStart'
    top = @ui.contentRegion.offset().top - $(window).scrollTop()
    @_reset()
    @$el.addClass 'content-container-visible content-container-fixed'
    @ui.contentRegion.css 'top', top
    $(window).scrollTop 0

  moveContentRightMiddle: =>
    log 'moveContentRightMiddle'
    @$el.addClass 'content-container-move-right'
    @$el.on transitionEnd, @moveContentRightEnd

  moveContentRightEnd: =>
    log 'moveContentRightEnd'
    @_reset()
    for iframeUrl, iframeView of @iframeViews
      iframeView.abortLoading()
      iframeView.hide()
      iframeView.deactivate()
    # @startLoadingNextIframe()

  _reset: ->
    @$el.off transitionEnd
    @$el.removeClass 'content-container-visible content-container-animated content-container-fixed content-container-move-right'
    @ui.contentRegion.css 'top', 0

  addIframe: (url, height) ->
    iframeView = new IframeView {url, height}
    iframeView.render()
    @ui.contentRegion.append iframeView.el
    @iframeViews[url] = iframeView
    # @startLoadingNextIframe()

  abortLoadingIframesExcept: (url) ->
    for iframeUrl, iframeView of @iframeViews
      iframeView.abortLoading() unless iframeUrl == url

  showIframe: (url) ->
    for iframeUrl, iframeView of @iframeViews
      iframeView.abortLoading() unless iframeUrl == url
      iframeView.startLoading() if iframeUrl == url
      if iframeUrl == url
        iframeView.show()
      else
        iframeView.hide()
        iframeView.deactivate()

  startLoadingNextIframe: ->
    for iframeUrl, iframeView of @iframeViews
      return if iframeView.isLoading()

    for iframeUrl, iframeView of @iframeViews
      if iframeView.needsLoading()
        iframeView.startLoading()
        return


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
    @$el.show()
    @$el.addClass 'menu-container-move-left'
    @$el.removeClass 'menu-container-animated'

  moveMenuContainerRightMiddle: =>
    log 'moveMenuContainerRightMiddle'
    @$el.off transitionEnd
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
    @_href = @$el.data('href') || @$el.attr('href')
    @_link = @$el.attr('href')
    @_height = @$el.data('height')
    @_id = @$el.attr('id')
    @_linkText = @$('.js-link').html()

    @$originalContainer = @$el.parent()
    @iframeView = contentContainerView.addIframe @href(), @_height

    @_makeA()

  href: -> @_href

  _makeDiv: ->
    $newEl = $("<div>" + @$el.html() + "</div>")
    $newEl.addClass @$el.attr('class')
    @$el.replaceWith($newEl)
    @$el = $newEl

    @$('.js-back').html '<a href="#" class="item-back"><span class="icon-hand-left"></span> Back</a>'
    @$('.js-link').html """<a href="#{@_link}" class="item-link" target="_blank">#{@_linkText}</a>"""

  _makeA: ->
    @$('.js-back').html ''
    @$('.js-link').html @_linkText

    $newEl = $("<a>" + @$el.html() + "</a>")
    $newEl.addClass @$el.attr('class')
    $newEl.attr 'href', '#' + @_id
    @$el.replaceWith($newEl)
    @$el = $newEl

  selectItemStart: =>
    log 'selectItemStart'
    window.selectedItemView?.deselectItemEnd()
    window.selectedItemView = this
    @lastScrollTop = $(window).scrollTop()
    @_makeDiv()
    @reset()
    offset = @$originalContainer.offset()
    @$el.css
      left: offset.left + 1
      top: offset.top + 8 - $(window).scrollTop()
      right: $(window).width() - offset.left - @$el.outerWidth()
    @$el.addClass 'item-select-start'
    $('.js-selected-item-container').html(@$el)
    $('.js-selected-item-container').addClass 'selected-item-container-active'
    @$originalContainer.addClass 'menu-item-container-selected'

    menuContainerView.moveMenuContainerLeftStart()
    backgroundView.moveBackgroundLeftStart()
    _.delay @selectItemMiddle, 150
    _.delay (=> contentContainerView.showContentStart @href()), 500
    contentContainerView.abortLoadingIframesExcept @href()

  selectItemMiddle: =>
    log 'selectItemMiddle'
    @reset()
    @$el.css left: '', top: '', right: ''
    @$el.addClass 'item-select-middle'
    $('.js-selected-item-container').addClass 'selected-item-container-active'
    @$originalContainer.addClass 'menu-item-container-selected'
    @$el.on transitionEnd, @selectItemEnd

  selectItemEnd: (e) =>
    return unless !e? || e.target == @$el[0]

    log 'selectItemEnd'
    window.selectedItemView?.deselectItemEnd()
    window.selectedItemView = this
    @_makeDiv()
    @reset()
    @$el.css left: '', top: '', right: ''
    $('.js-selected-item-container').html(@$el)
    $('.js-selected-item-container').addClass 'selected-item-container-active'

  deselectItemStart: =>
    log 'deselectItemStart'
    @reset()
    @$el.css left: '', top: '', right: ''
    $('.js-selected-item-container').addClass 'selected-item-container-active selected-item-container-deselect-start'
    @$el.css top: -Math.min(65, $(window).scrollTop())
    backgroundView.moveBackgroundRightStart()
    menuContainerView.moveMenuContainerRightStart()
    contentContainerView.moveContentRightStart()
    _.defer @deselectItemMiddle

  deselectItemMiddle: =>
    log 'deselectItemMiddle'
    @reset()
    $('.js-selected-item-container').addClass 'selected-item-container-deselect-middle'
    # Stuff above explicitly before scroll top, as that rerenders in FF

    # This seems to fix a bug in Chrome where the scroll position stays 0, even when trying to
    # explicitly set the scrollTop to the correct value below
    $(window).scrollTop 1

    newScrollTop = @_restoreScrollTop @lastScrollTop
    $(window).scrollTop newScrollTop
    log 'restoring scroll position', $(window).scrollTop(), newScrollTop, @lastScrollTop

    windowWidth = $(window).width()
    @$el.css
      left: windowWidth/2 - 700/2 + 150
      right: windowWidth/2 - 700/2
      top: @$originalContainer.offset().top + 8 - $(window).scrollTop()

    _.delay menuContainerView.moveMenuContainerRightMiddle, 300

  deselectItemEnd: =>
    log 'deselectItemEnd'
    @_makeA()
    @reset()
    @$el.css left: '', top: '', right: ''
    @$originalContainer.html(@$el)
    window.selectedItemView = null

  reset: =>
    @$el.removeClass 'item-select-start item-select-middle'
    @$el.off transitionEnd
    @$originalContainer.removeClass 'menu-item-container-selected'
    $('.js-selected-item-container').removeClass 'selected-item-container-active selected-item-container-deselect-start selected-item-container-deselect-middle'

  _restoreScrollTop: (scrollTop) ->
    windowHeight = $(window).height()
    pageHeight = menuContainerView.height()
    containerOffset = @$originalContainer.offset()

    unless scrollTop? && scrollTop+100 < containerOffset.top < scrollTop+windowHeight-100
      scrollTop = containerOffset.top + 36/2 - windowHeight/2

    if scrollTop >= pageHeight - windowHeight
      scrollTop = pageHeight - windowHeight

    Math.floor(scrollTop)


class IframeView extends Backbone.Marionette.ItemView

  className: 'content-iframe'

  template: -> ''

  needsLoading: -> !@loading && !@loaded

  isLoading: -> @loading

  onRender: ->
    @hide()

  show: ->
    @$el.removeClass 'content-iframe-hidden'

  hide: ->
    @$el.addClass 'content-iframe-hidden'

  deactivate: -> @_iframe()[0]?.contentWindow?.jppDeactivate?()

  startLoading: ->
    return unless @needsLoading()

    log 'startLoading', @options.url
    @loading = true
    @$el.html "<iframe scrolling='no' frameborder='0' src='#{@options.url}'></iframe>"
    @_updateHeight()
    @_iframe().on 'load', => @onLoad()

  abortLoading: ->
    return if @loaded

    log 'abortLoading', @options.url
    @loading = false
    @$el.html ''

  onLoad: ->
    log 'onLoad', @options.url
    @loaded = true
    @loading = false
    @_setClass()
    @_updateHeight()
    # contentContainerView.startLoadingNextIframe()

  _iframe: ->
    @$('iframe')

  _updateHeight: ->
    if @options.height?
      @_iframe().height @options.height
      return

    iframe = @_iframe()[0]
    try
      doc = iframe.contentDocument ? iframe.contentWindow.document
    catch e
      console.error e

    # based on Bret Victor's height calculation
    height = 0
    if doc
      db = doc.body
      dde = doc.documentElement
      height = Math.max height, db.scrollHeight, db.offsetHeight, db.clientHeight if db?
      height = Math.max height, dde.scrollHeight, dde.offsetHeight, dde.clientHeight if dde?

    @_iframe().height height

  _setClass: ->
    doc = @_iframe()[0].contentDocument;

    if doc
      $(doc.body.parentNode).addClass('jpp-iframe')
      $(doc.documentElement).find('html').addClass('jpp-iframe')

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
    @_scrollTop = @$window.scrollTop()
    log '@_scrollTop', @_scrollTop

  fixScrollPosition: ->
    @_previousScrollTop = @_scrollTop = @$window.scrollTop()

  _showIndex: ->
    $(window).scrollTop @_previousScrollTop # prevent browser resetting of scrollTop
    @_index()

  _showPage: (page) ->
    $(window).scrollTop @_previousScrollTop # prevent browser resetting of scrollTop
    @_page(page)

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
