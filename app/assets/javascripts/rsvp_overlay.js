function toggleOverlay() {
  var overlay = document.getElementById('overlay');
  var contentBox = document.getElementById('content_box');
  overlay.style.opacity = .8;
  if (overlay.style.display == 'block') {
    overlay.style.display = 'none';
    contentBox.style.display = 'none';
  } else {
    overlay.style.display = 'block';
    contentBox.style.display = 'block';
  }
}
