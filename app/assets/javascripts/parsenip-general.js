var timeoutFlash = function(){
  setTimeout(function(){
    $('.flash-outer').fadeOut(500);
  }, 2500);
}

var generateJavascript = function(){
  $('.generate-javascript').click(function(e){
    e.preventDefault();
    var id = $(this).attr('data-id');
    $('.javascript-container[data-id=' + id + ']').show();
  });
}

var parsenip = function(){
  timeoutFlash();
  generateJavascript();
}

$(document).ready(parsenip);
$(document).on('page:load', parsenip);
