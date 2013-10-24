(function() {
  var BackgroundView, ContentContainerView, IframeView, ItemView, MenuContainerView, Router, log, setCss3, transitionEnd, _ref, _ref1, _ref2, _ref3, _ref4, _ref5,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  setCss3 = function($element, name, value, addBrowserToValue) {
    var browser, _i, _len, _ref, _results;
    _ref = ['', '-ms-', '-moz-', '-webkit-', '-o-'];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      browser = _ref[_i];
      if (addBrowserToValue) {
        _results.push($element.css(browser + name, browser + value));
      } else {
        _results.push($element.css(browser + name, value));
      }
    }
    return _results;
  };

  log = function() {};

  transitionEnd = 'transitionend webkitTransitionEnd oTransitionEnd';

  window.selectedItemView = null;

  BackgroundView = (function(_super) {
    __extends(BackgroundView, _super);

    function BackgroundView() {
      this.moveBackgroundRightEnd = __bind(this.moveBackgroundRightEnd, this);
      this.moveBackgroundRightMiddle = __bind(this.moveBackgroundRightMiddle, this);
      this.moveBackgroundRightStart = __bind(this.moveBackgroundRightStart, this);
      this.moveBackgroundLeftEnd = __bind(this.moveBackgroundLeftEnd, this);
      this.moveBackgroundLeftStart = __bind(this.moveBackgroundLeftStart, this);
      this._onScroll = __bind(this._onScroll, this);
      _ref = BackgroundView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    BackgroundView.prototype._topOffset = 100;

    BackgroundView.prototype.template = function() {
      return '';
    };

    BackgroundView.prototype.onRender = function() {
      var _onScroll;
      this._height = 0;
      this.$window = $(window);
      _onScroll = _.throttle(this._onScroll, 5);
      this.$window.on('scroll', _onScroll);
      return _onScroll();
    };

    BackgroundView.prototype._onScroll = function() {
      if (this._stopUpdating) {
        return;
      }
      this._updateScroll();
      return this._updateHeight();
    };

    BackgroundView.prototype._updateScroll = function() {
      var x;
      this._y = this._scrollTopToY();
      x = (this._movedLeft ? -200 : 0);
      return setCss3(this.$el, 'transform', "translate3d(" + x + "px, " + (-this._y) + "px, -1px)");
    };

    BackgroundView.prototype._updateHeight = function() {
      if (this._y + this.$window.height() >= this._height - this._topOffset - 100) {
        this._height = this._y + this.$window.height() + this._topOffset + 500;
        return this.$el.height(this._height);
      }
    };

    BackgroundView.prototype._scrollTopToY = function() {
      var scrollTop;
      scrollTop = this._movedUp ? 0 : this.$window.scrollTop();
      return Math.max(-this._topOffset, parseFloat((scrollTop / 4).toFixed(2)) + 0.005);
    };

    BackgroundView.prototype.moveBackgroundLeftStart = function() {
      log('moveBackgroundLeftStart');
      this.$el.off(transitionEnd);
      this._stopUpdating = false;
      this._movedLeft = true;
      this._movedUp = true;
      this._updateScroll();
      this.$el.addClass('background-animating');
      return this.$el.on(transitionEnd, this.moveBackgroundLeftEnd);
    };

    BackgroundView.prototype.moveBackgroundLeftEnd = function() {
      log('moveBackgroundLeftEnd');
      this.$el.off(transitionEnd);
      this._stopUpdating = false;
      this._movedLeft = true;
      this._movedUp = false;
      this.$el.removeClass('background-animating');
      return this._updateScroll();
    };

    BackgroundView.prototype.moveBackgroundRightStart = function() {
      log('moveBackgroundRightStart');
      this.$el.off(transitionEnd);
      this._updateScroll();
      this._stopUpdating = true;
      this._movedLeft = false;
      return this._movedUp = false;
    };

    BackgroundView.prototype.moveBackgroundRightMiddle = function() {
      log('moveBackgroundRightMiddle');
      this.$el.off(transitionEnd);
      this.$el.addClass('background-animating');
      this._stopUpdating = false;
      this._movedLeft = false;
      this._movedUp = false;
      this._updateScroll();
      return this.$el.on(transitionEnd, this.moveBackgroundRightEnd);
    };

    BackgroundView.prototype.moveBackgroundRightEnd = function() {
      log('moveBackgroundRightEnd');
      this.$el.off(transitionEnd);
      this.$el.removeClass('background-animating');
      this._stopUpdating = false;
      this._movedLeft = false;
      this._movedUp = false;
      return this._updateScroll();
    };

    return BackgroundView;

  })(Backbone.Marionette.ItemView);

  ContentContainerView = (function(_super) {
    __extends(ContentContainerView, _super);

    function ContentContainerView() {
      this.moveContentRightEnd = __bind(this.moveContentRightEnd, this);
      this.moveContentRightMiddle = __bind(this.moveContentRightMiddle, this);
      this.moveContentRightStart = __bind(this.moveContentRightStart, this);
      this.showContentEnd = __bind(this.showContentEnd, this);
      this.showContentStart = __bind(this.showContentStart, this);
      this.template = __bind(this.template, this);
      _ref1 = ContentContainerView.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    ContentContainerView.prototype.template = function() {
      return "<div class=\"content js-content-region js-iframe-region\"></div>";
    };

    ContentContainerView.prototype.ui = {
      contentRegion: '.js-content-region'
    };

    ContentContainerView.prototype.regions = {
      iframeRegion: '.js-iframe-region'
    };

    ContentContainerView.prototype.initialize = function() {
      return this.iframeHeights = {};
    };

    ContentContainerView.prototype.showContentStart = function(url) {
      log('showContentStart');
      this._reset();
      this.showIframe(url);
      this.$el.on(transitionEnd, this.showContentEnd);
      this.$el.addClass('content-container-visible content-container-animated');
      return $(window).scrollTop(0);
    };

    ContentContainerView.prototype.showContentEnd = function() {
      log('showContentEnd');
      this._reset();
      this.$el.addClass('content-container-visible');
      $(window).scrollTop(0);
      return window.router.fixScrollPosition();
    };

    ContentContainerView.prototype.moveContentRightStart = function() {
      var top;
      log('moveContentRightStart');
      top = this.ui.contentRegion.offset().top - $(window).scrollTop();
      this._reset();
      this.$el.addClass('content-container-visible content-container-fixed');
      this.ui.contentRegion.css('top', top);
      return $(window).scrollTop(0);
    };

    ContentContainerView.prototype.moveContentRightMiddle = function() {
      log('moveContentRightMiddle');
      this.$el.addClass('content-container-move-right');
      return this.$el.on(transitionEnd, this.moveContentRightEnd);
    };

    ContentContainerView.prototype.moveContentRightEnd = function() {
      log('moveContentRightEnd');
      this._reset();
      return this.iframeRegion.close();
    };

    ContentContainerView.prototype._reset = function() {
      this.$el.off(transitionEnd);
      this.$el.removeClass('content-container-visible content-container-animated content-container-fixed content-container-move-right');
      return this.ui.contentRegion.css('top', 0);
    };

    ContentContainerView.prototype.addIframe = function(url, height) {
      return this.iframeHeights[url] = height;
    };

    ContentContainerView.prototype.showIframe = function(url) {
      return this.iframeRegion.show(new IframeView({
        url: url,
        height: this.iframeHeights[url]
      }));
    };

    return ContentContainerView;

  })(Backbone.Marionette.Layout);

  MenuContainerView = (function(_super) {
    __extends(MenuContainerView, _super);

    function MenuContainerView() {
      this.moveMenuContainerRightEnd = __bind(this.moveMenuContainerRightEnd, this);
      this.moveMenuContainerRightMiddle = __bind(this.moveMenuContainerRightMiddle, this);
      this.moveMenuContainerRightStart = __bind(this.moveMenuContainerRightStart, this);
      this.moveMenuContainerLeftEnd = __bind(this.moveMenuContainerLeftEnd, this);
      this.moveMenuContainerLeftStart = __bind(this.moveMenuContainerLeftStart, this);
      _ref2 = MenuContainerView.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    MenuContainerView.prototype.moveMenuContainerLeftStart = function() {
      log('moveMenuContainerLeftStart');
      this.$el.off(transitionEnd);
      this.$el.addClass('menu-container-move-left menu-container-animated');
      this.$el.height($(window).scrollTop() + $(window).height());
      return this.$el.on(transitionEnd, this.moveMenuContainerLeftEnd);
    };

    MenuContainerView.prototype.moveMenuContainerLeftEnd = function(e) {
      if (!((e == null) || e.target === this.$el[0])) {
        return;
      }
      log('moveMenuContainerLeftEnd');
      this.$el.off(transitionEnd);
      this.$el.hide();
      this.$el.removeClass('menu-container-move-left menu-container-animated');
      return this.$el.height('101%');
    };

    MenuContainerView.prototype.moveMenuContainerRightStart = function() {
      log('moveMenuContainerRightStart');
      this.$el.off(transitionEnd);
      this.$el.show();
      this.$el.addClass('menu-container-move-left');
      return this.$el.removeClass('menu-container-animated');
    };

    MenuContainerView.prototype.moveMenuContainerRightMiddle = function() {
      log('moveMenuContainerRightMiddle');
      this.$el.off(transitionEnd);
      this.$el.addClass('menu-container-animated');
      this.$el.removeClass('menu-container-move-left');
      this.$el.on(transitionEnd, this.moveMenuContainerRightEnd);
      contentContainerView.moveContentRightMiddle();
      return backgroundView.moveBackgroundRightMiddle();
    };

    MenuContainerView.prototype.moveMenuContainerRightEnd = function(e) {
      if (e.target !== this.$el[0]) {
        return;
      }
      log('moveMenuContainerRightEnd');
      this.$el.off(transitionEnd);
      this.$el.removeClass('menu-container-animated');
      window.selectedItemView.deselectItemEnd();
      return window.router.fixScrollPosition();
    };

    MenuContainerView.prototype.height = function() {
      return this.$('.js-menu').height();
    };

    return MenuContainerView;

  })(Backbone.Marionette.ItemView);

  ItemView = (function(_super) {
    __extends(ItemView, _super);

    function ItemView() {
      this.reset = __bind(this.reset, this);
      this.deselectItemEnd = __bind(this.deselectItemEnd, this);
      this.deselectItemMiddle = __bind(this.deselectItemMiddle, this);
      this.deselectItemStart = __bind(this.deselectItemStart, this);
      this.selectItemEnd = __bind(this.selectItemEnd, this);
      this.selectItemMiddle = __bind(this.selectItemMiddle, this);
      this.selectItemStart = __bind(this.selectItemStart, this);
      _ref3 = ItemView.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    ItemView.prototype.initialize = function() {
      this._href = this.$el.data('href') || this.$el.attr('href');
      this._link = this.$el.attr('href');
      this._height = this.$el.data('height');
      this._id = this.$el.attr('id');
      this._linkText = this.$('.js-link').html();
      this.$originalContainer = this.$el.parent();
      this.iframeView = contentContainerView.addIframe(this.href(), this._height);
      return this._makeA();
    };

    ItemView.prototype.href = function() {
      return this._href;
    };

    ItemView.prototype._makeDiv = function() {
      var $newEl;
      $newEl = $("<div>" + this.$el.html() + "</div>");
      $newEl.addClass(this.$el.attr('class'));
      this.$el.replaceWith($newEl);
      this.$el = $newEl;
      this.$('.js-back').html('<a href="#" class="item-back"><span class="icon-hand-left"></span> Back</a>');
      return this.$('.js-link').html("<a href=\"" + this._link + "\" class=\"item-link\" target=\"_blank\">" + this._linkText + "</a>");
    };

    ItemView.prototype._makeA = function() {
      var $newEl;
      this.$('.js-back').html('');
      this.$('.js-link').html(this._linkText);
      $newEl = $("<a>" + this.$el.html() + "</a>");
      $newEl.addClass(this.$el.attr('class'));
      $newEl.attr('href', '#' + this._id);
      this.$el.replaceWith($newEl);
      return this.$el = $newEl;
    };

    ItemView.prototype.selectItemStart = function() {
      var offset, _ref4,
        _this = this;
      log('selectItemStart');
      if ((_ref4 = window.selectedItemView) != null) {
        _ref4.deselectItemEnd();
      }
      window.selectedItemView = this;
      this.lastScrollTop = $(window).scrollTop();
      this._makeDiv();
      this.reset();
      offset = this.$originalContainer.offset();
      this.$el.css({
        left: offset.left + 1,
        top: offset.top + 7 - $(window).scrollTop(),
        right: $(window).width() - offset.left - this.$el.outerWidth()
      });
      this.$el.addClass('item-select-start');
      $('.js-selected-item-container').html(this.$el);
      $('.js-selected-item-container').addClass('selected-item-container-active');
      this.$originalContainer.addClass('menu-item-container-selected');
      menuContainerView.moveMenuContainerLeftStart();
      backgroundView.moveBackgroundLeftStart();
      _.delay(this.selectItemMiddle, 150);
      return _.delay((function() {
        return contentContainerView.showContentStart(_this.href());
      }), 500);
    };

    ItemView.prototype.selectItemMiddle = function() {
      log('selectItemMiddle');
      this.reset();
      this.$el.css({
        left: '',
        top: '',
        right: ''
      });
      this.$el.addClass('item-select-middle');
      $('.js-selected-item-container').addClass('selected-item-container-active');
      this.$originalContainer.addClass('menu-item-container-selected');
      return this.$el.on(transitionEnd, this.selectItemEnd);
    };

    ItemView.prototype.selectItemEnd = function(e) {
      var _ref4;
      if (!((e == null) || e.target === this.$el[0])) {
        return;
      }
      log('selectItemEnd');
      if ((_ref4 = window.selectedItemView) != null) {
        _ref4.deselectItemEnd();
      }
      window.selectedItemView = this;
      this._makeDiv();
      this.reset();
      this.$el.css({
        left: '',
        top: '',
        right: ''
      });
      $('.js-selected-item-container').html(this.$el);
      return $('.js-selected-item-container').addClass('selected-item-container-active');
    };

    ItemView.prototype.deselectItemStart = function() {
      log('deselectItemStart');
      this.reset();
      this.$el.css({
        left: '',
        top: '',
        right: ''
      });
      $('.js-selected-item-container').addClass('selected-item-container-active selected-item-container-deselect-start');
      this.$el.css({
        top: -Math.min(65, $(window).scrollTop())
      });
      backgroundView.moveBackgroundRightStart();
      menuContainerView.moveMenuContainerRightStart();
      contentContainerView.moveContentRightStart();
      return _.defer(this.deselectItemMiddle);
    };

    ItemView.prototype.deselectItemMiddle = function() {
      var newScrollTop, windowWidth;
      log('deselectItemMiddle');
      this.reset();
      $('.js-selected-item-container').addClass('selected-item-container-deselect-middle');
      $(window).scrollTop(1);
      newScrollTop = this._restoreScrollTop(this.lastScrollTop);
      $(window).scrollTop(newScrollTop);
      log('restoring scroll position', $(window).scrollTop(), newScrollTop, this.lastScrollTop);
      windowWidth = $(window).width();
      this.$el.css({
        left: windowWidth / 2 - 700 / 2 + 150,
        right: windowWidth / 2 - 700 / 2,
        top: this.$originalContainer.offset().top + 7 - $(window).scrollTop()
      });
      return _.delay(menuContainerView.moveMenuContainerRightMiddle, 300);
    };

    ItemView.prototype.deselectItemEnd = function() {
      log('deselectItemEnd');
      this._makeA();
      this.reset();
      this.$el.css({
        left: '',
        top: '',
        right: ''
      });
      this.$originalContainer.html(this.$el);
      return window.selectedItemView = null;
    };

    ItemView.prototype.reset = function() {
      this.$el.removeClass('item-select-start item-select-middle');
      this.$el.off(transitionEnd);
      this.$originalContainer.removeClass('menu-item-container-selected');
      return $('.js-selected-item-container').removeClass('selected-item-container-active selected-item-container-deselect-start selected-item-container-deselect-middle');
    };

    ItemView.prototype._restoreScrollTop = function(scrollTop) {
      var containerOffset, pageHeight, windowHeight, _ref4;
      windowHeight = $(window).height();
      pageHeight = menuContainerView.height();
      containerOffset = this.$originalContainer.offset();
      if (!((scrollTop != null) && (scrollTop + 100 < (_ref4 = containerOffset.top) && _ref4 < scrollTop + windowHeight - 100))) {
        scrollTop = containerOffset.top + 36 / 2 - windowHeight / 2;
      }
      if (scrollTop >= pageHeight - windowHeight) {
        scrollTop = pageHeight - windowHeight;
      }
      return Math.floor(scrollTop);
    };

    return ItemView;

  })(Backbone.Marionette.ItemView);

  IframeView = (function(_super) {
    __extends(IframeView, _super);

    function IframeView() {
      _ref4 = IframeView.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    IframeView.prototype.className = 'content-iframe';

    IframeView.prototype.template = function() {
      return '';
    };

    IframeView.prototype.onRender = function() {
      var _this = this;
      log('startLoading', this.options.url);
      this.$el.html("<iframe scrolling='no' frameborder='0' src='" + this.options.url + "'></iframe>");
      this._updateHeight();
      return this._iframe().on('load', function() {
        return _this.onLoad();
      });
    };

    IframeView.prototype.onLoad = function() {
      log('onLoad', this.options.url);
      this._setClass();
      return this._updateHeight();
    };

    IframeView.prototype._iframe = function() {
      return this.$('iframe');
    };

    IframeView.prototype._updateHeight = function() {
      var db, dde, doc, e, height, iframe, _ref5;
      if (this.options.height != null) {
        this._iframe().height(this.options.height);
        return;
      }
      iframe = this._iframe()[0];
      try {
        doc = (_ref5 = iframe.contentDocument) != null ? _ref5 : iframe.contentWindow.document;
      } catch (_error) {
        e = _error;
        console.error(e);
      }
      height = 0;
      if (doc) {
        db = doc.body;
        dde = doc.documentElement;
        if (db != null) {
          height = Math.max(height, db.scrollHeight, db.offsetHeight, db.clientHeight);
        }
        if (dde != null) {
          height = Math.max(height, dde.scrollHeight, dde.offsetHeight, dde.clientHeight);
        }
      }
      return this._iframe().height(height);
    };

    IframeView.prototype._setClass = function() {
      var doc;
      doc = this._iframe()[0].contentDocument;
      if (doc) {
        $(doc.body.parentNode).addClass('jpp-iframe');
        return $(doc.documentElement).find('html').addClass('jpp-iframe');
      }
    };

    return IframeView;

  })(Backbone.Marionette.ItemView);

  Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      this._onScroll = __bind(this._onScroll, this);
      _ref5 = Router.__super__.constructor.apply(this, arguments);
      return _ref5;
    }

    Router.prototype.routes = {
      '': '_showIndex',
      ':page': '_showPage'
    };

    Router.prototype.initialize = function() {
      this.$window = $(window);
      this.$window.on('scroll', _.throttle(this._onScroll, 5));
      this._onScroll();
      return this._onScroll();
    };

    Router.prototype._onScroll = function() {
      this._previousScrollTop = this._scrollTop;
      this._scrollTop = this.$window.scrollTop();
      return log('@_scrollTop', this._scrollTop);
    };

    Router.prototype.fixScrollPosition = function() {
      return this._previousScrollTop = this._scrollTop = this.$window.scrollTop();
    };

    Router.prototype._showIndex = function() {
      $(window).scrollTop(this._previousScrollTop);
      return this._index();
    };

    Router.prototype._showPage = function(page) {
      $(window).scrollTop(this._previousScrollTop);
      return this._page(page);
    };

    Router.prototype.navigateToIndex = function() {
      this.navigate('');
      return this._index();
    };

    Router.prototype.navigateToPage = function(page) {
      this.navigate(page);
      return this._page(page);
    };

    Router.prototype._index = function() {
      if (this._loaded && (typeof selectedItemView !== "undefined" && selectedItemView !== null)) {
        selectedItemView.deselectItemStart();
      }
      return this._showBodyContent();
    };

    Router.prototype._page = function(page) {
      if (itemViews[page] != null) {
        if (!this._loaded || (typeof selectedItemView !== "undefined" && selectedItemView !== null)) {
          this._showFirstItemView(itemViews[page]);
        } else {
          itemViews[page].selectItemStart();
        }
      } else {
        this._index();
      }
      return this._showBodyContent();
    };

    Router.prototype._showFirstItemView = function(itemView) {
      itemView.selectItemEnd();
      menuContainerView.moveMenuContainerLeftEnd();
      contentContainerView.showContentStart(itemView.href());
      return backgroundView.moveBackgroundLeftEnd();
    };

    Router.prototype._showBodyContent = function() {
      this._loaded = true;
      return $('.body-loading').removeClass('body-loading');
    };

    return Router;

  })(Backbone.Router);

  $(function() {
    var el, email, _i, _len, _ref6;
    window.backgroundView = new BackgroundView({
      el: $('.js-background')
    }).render();
    window.contentContainerView = new ContentContainerView({
      el: $('.js-content-container')
    }).render();
    window.menuContainerView = new MenuContainerView({
      el: $('.js-menu-container')
    });
    window.itemViews = {};
    _ref6 = $('.js-item');
    for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
      el = _ref6[_i];
      window.itemViews[$(el).attr('id')] = new ItemView({
        el: el
      });
    }
    window.router = new Router;
    Backbone.history.start();
    email = 'mailto:j' + '@' + 'npaulpos';
    email += '.ma';
    return $('#email').attr('href', email);
  });

}).call(this);
