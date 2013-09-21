window.showYoutube = function(videos) {

  window.onYouTubeIframeAPIReady = function() {
    for (var i=0; i<videos.length; i++) {
      video = videos[i];
      video.player = new YT.Player(video.videoId, video);
    }
  };

  window.jppDeactivate = function() {
    for (var i=0; i<videos.length; i++) {
      if (videos[i].player) videos[i].player.stopVideo();
    }
  };

  var tag = document.createElement('script');
  tag.src = "https://www.youtube.com/iframe_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
};
