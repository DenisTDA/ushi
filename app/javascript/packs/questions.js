$(document).on('turbolinks:load', function() {
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId')
    $('form#edit-question-'+ questionId).removeClass('hidden')
  })

  $('.questions').on('click', '.delete-question-link', function(e) {
    if (confirm('Are you shure?')){
      const questionId = $(this).data('questionId')
      $('#question-block-' + questionId).remove()
      $('.flash').html("<div class='alert alert-info' role='alert'>Question successfully deleted </div>")
    }
  })
})
