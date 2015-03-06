var timeoutFlash = function(){
  setTimeout(function(){
    $('.flash-outer').fadeOut(500);
  }, 2500);
}

var parsenip = function(){
  timeoutFlash();
}

$(document).ready(parsenip);
$(document).on('page:load', parsenip);
