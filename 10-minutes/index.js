// Adapted from https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API
function addVisibilityHandler(func) {
  // Set the name of the hidden property and the change event for visibility
  var hidden, visibilityChange;
  if (typeof document.hidden !== "undefined") { // Opera 12.10 and Firefox 18 and later support
    hidden = "hidden";
    visibilityChange = "visibilitychange";
  } else if (typeof document.msHidden !== "undefined") {
    hidden = "msHidden";
    visibilityChange = "msvisibilitychange";
  } else if (typeof document.webkitHidden !== "undefined") {
    hidden = "webkitHidden";
    visibilityChange = "webkitvisibilitychange";
  }

  function handleVisibilityChange() {
    if (document[hidden]) {
      func(false);
    } else {
      func(true);
    }
  }

  if (typeof document.addEventListener !== "undefined" && typeof document[hidden] !== "undefined") {
    // Handle page visibility change
    document.addEventListener(visibilityChange, handleVisibilityChange, false);
  }
}


$(function() {
  // Wrap everything in single letter spans.
  {
    // From https://stackoverflow.com/a/10730777
    function textNodesUnder(el) {
      var n, a=[], walk=document.createTreeWalker(el,NodeFilter.SHOW_TEXT,null,false);
      while(n=walk.nextNode()) a.push(n);
      return a;
    }
    var allTextNodes = textNodesUnder(document.querySelector('article'));

    allTextNodes.forEach(function(node) {
      // https://stackoverflow.com/a/15553884
      var replacementNode = document.createElement('span');
      replacementNode.innerHTML = node.textContent.replace(/\w/g, function(text) {
        return '<span class="single-letter">' + text + '</span>';
      });
      node.parentNode.insertBefore(replacementNode, node);
      node.parentNode.removeChild(node);
    });
  }

  var singleLetterSpans = Array.from(document.querySelectorAll('.single-letter'));
  singleLetterSpans = _.shuffle(singleLetterSpans).slice(0, Math.floor(singleLetterSpans.length / 10));
  var fractionsWhenToIntroduceCraziness =
    _.shuffle(singleLetterSpans.map(function(__, index) {
      return 1 - (index / singleLetterSpans.length * 0.5);
    }));
  var crazyCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz0123456789';
  var originalTexts = singleLetterSpans.map(function(span) {
    return span.textContent;
  });

  singleLetterSpans.forEach(function(span) {
    span.style.width = span.offsetWidth + 'px';
  });

  var clockSecondsStartOfCraziness = 60 * 8;
  var clockSeconds = 60 * 10;
  var decreaseMs = 800;
  var intervalMs = 60;
  var enabled = true;

  function tickClock() {
    if (!enabled) return;

    clockSeconds -= intervalMs / decreaseMs;
    if (clockSeconds < 0) {
      clockSeconds = 0;
    }
    var roundedClockSeconds = Math.round(clockSeconds);
    var minutes = Math.floor(roundedClockSeconds / 60);
    if (minutes < 10) minutes = '0' + minutes;
    var seconds = roundedClockSeconds % 60;
    if (seconds < 10) seconds = '0' + seconds;
    $('.counter-numbers').text('00:' + minutes + ':' + seconds);

    fractionsWhenToIntroduceCraziness.forEach(function(fraction, index) {
      if (clockSeconds < clockSecondsStartOfCraziness * fraction) {
        singleLetterSpans[index].style.visibility = 'hidden';
        singleLetterSpans[index].innerHTML =
          originalTexts[index] + '<span class="single-letter-craziness">' +
          crazyCharacters[Math.floor(Math.random() * crazyCharacters.length)] + '</span>';
      }
    });

    if (clockSeconds < clockSecondsStartOfCraziness - 10) {
      $('.counter-reset').show();
    }
    if (clockSeconds < clockSecondsStartOfCraziness - 20) {
      $('.counter-reset').addClass('counter-reset-big');
    }
  }

  var interval = setInterval(tickClock, intervalMs);

  // Pause clock ticks when page is not active.
  addVisibilityHandler(function(visible) {
    clearInterval(interval);
    if (visible && enabled) {
      interval = setInterval(tickClock, intervalMs);
    }
  });

  $('.counter-numbers').click(function(event) {
    event.preventDefault();
    if (enabled) {
      decreaseMs = 20;
    } else {
      decreaseMs = 800;
      clockSeconds = 60 * 10 - 1;
      enabled = true;
      clearInterval(interval);
      interval = setInterval(tickClock, intervalMs);
    }
  });

  $('.counter-reset').click(function(event) {
    event.preventDefault();
    enabled = false;
    clearInterval(interval);
    originalTexts.forEach(function(text, index) {
      singleLetterSpans[index].style.visibility = 'visible';
      singleLetterSpans[index].textContent = text;
    });
    $('.counter-reset').hide();
    $('.counter-reset').removeClass('counter-reset-big');
  });
});
