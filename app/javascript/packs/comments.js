$(document).on('turbolinks:load', function() {

  $('.new-comment-link').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    const commentableType = $(this).data('block')
    const commentableId = $(this).data('commentable-id')
    const formComment = $('.comments-' + commentableType + '-' + commentableId).find('form#new-comment-'+ commentableId)
    $(formComment).find('textarea').val('')
    formComment.removeClass('hidden')
  })

  $('.comment-form-block').on('ajax:success', function(e) {
    const comment = e.detail[0][0].comment
    const elemClass = '.comments-' + comment.commentable_type.toLowerCase()+ '-' + comment.commentable_id 
    $(elemClass).find('form').addClass('hidden')
    $(elemClass).find('.new-comment-link').removeClass('hidden')
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0].errors
      $.each(errors, function(index, value) {
        $('.question-errors').html('<div class="alert alert-danger" role="alert">' + value + '</div>')
      })
    })
})
