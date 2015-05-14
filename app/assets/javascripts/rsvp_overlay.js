function toggleRSVPOverlay(formID) {
  var overlay = document.getElementById('overlay');
  var form = document.getElementById(formID);
  overlay.style.opacity = .8;
  if (overlay.style.display == 'block') {
    overlay.style.display = 'none';
    form.style.display = 'none';
  } else {
    overlay.style.display = 'block';
    form.style.display = 'block';
  }
}
