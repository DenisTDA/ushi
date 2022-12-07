$(document).on('turbolinks:load', function() {
  let formEdit = $('.comments-question').on('click', '.new-comment-link', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    const questionId = $(this).data('commentableId')
    
    let form = $('form#new-comment-'+ questionId)
    $('form#new-comment-'+ questionId).removeClass('hidden')
    return form
  })

  formEdit.on('ajax:success', function(e) {
    const comment = e.detail[0][0].comment
    $('textarea').val('')
    $('form').attr('id', 'new-comment-'+ comment.commentable_id).addClass('hidden')
    $('.new-comment-link').removeClass('hidden')

  })
    .on('ajax:error', function(e) {
      console.log(e)
      let errors = e.detail[0][1].errors
      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      })
    })
})
