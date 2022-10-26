$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId')
    $('form#edit-answer-'+ answerId).removeClass('hidden')
  })

  $('.answers').on('click', '.delete-answer-link', function(e) {
    if (confirm('Are you shure?')){
      const answerId = $(this).data('answerId')
      $('#answer-block-' + answerId).remove()
      $('.flash').html('')
      $('.flash').html("<div class='alert alert-info' role='alert'>Answer successfully deleted </div>")
    }
  })
})
