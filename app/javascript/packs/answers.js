$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId')
    $('form#edit-answer-'+ answerId).removeClass('hidden')
  })

  $(document).on('ajax:error', function(e) {

    let xhr = e.detail[2]

    $('.flash').html('<div class="alert alert-danger" role="alert">' + xhr.responseText + '</div>')
  
    setTimeout(() => {
      window.location.href='/users/sign_in'
    }, 3000);
  })
})
