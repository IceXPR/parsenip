var highlightWarning = function(node){
  node.css('border', 'rgb(248, 3, 3) dashed 2px');
}

var modal = function(){
  $('.modal-launcher').click(function(e){
    e.preventDefault();
    $('.modal').hide();
    var id = $(this).attr('data-id');
    $('.modal-shadow').fadeIn();
    $('#' + id).fadeIn(10); 
  })


  var closeModal = function(){
    $('.modal').hide();
    $('.modal-shadow').fadeOut();
    $('#api_key_permit_url').val('');
  }

  $('.modal-shadow').click(function(e){
    closeModal();
  })

  var postApiKey = function(){
    $.ajax({
      type: 'post',
      url: '/api_keys',
      data: $('.new_api_key').serialize()
    }).done(function(response){
      if(response['success']){
        closeModal();
        $('table').append('<tr><td>' + response['permit_url'] + 
                          '</td><td>' + response['api_key'] + 
                          '</td><td>' + 
                          '</td></tr>');
      }else{
        $('.error-message').html(response['message']);
      }
    })
  }

  $('.create-api-key').click(function(e){
    e.preventDefault();
    if(!$('#api_key_permit_url').val()){
      highlightWarning($('#api_key_permit_url'));
    }else{
      postApiKey();
    }
  })

  $('#api_key_permit_url').focus(function(){
    $(this).css('border', 'solid black 1px');
  })

}

$(document).ready(modal)
$(document).on('page:load', modal)
