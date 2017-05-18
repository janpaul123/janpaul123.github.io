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
  var clockSeconds = 60 * 10;
  var intervalMs = 1000;

  function tickClock() {
    clockSeconds--;
    if (clockSeconds < 0) {
      clockSeconds = 0;
    }
    var minutes = Math.floor(clockSeconds / 60);
    if (minutes < 10) minutes = '0' + minutes;
    var seconds = clockSeconds % 60;
    if (seconds < 10) seconds = '0' + seconds;
    $('.counter-numbers').text('00:' + minutes + ':' + seconds);
  }

  var interval = setInterval(tickClock, intervalMs);

  // Pause clock ticks when page is not active.
  addVisibilityHandler(function(visible) {
    clearInterval(interval);
    if (visible) {
      interval = setInterval(tickClock, intervalMs);
    }
  });

  $('.counter-numbers').click(function(event) {
    event.preventDefault();
    intervalMs = 20;
    clearInterval(interval);
    interval = setInterval(tickClock, intervalMs);
  });
});
