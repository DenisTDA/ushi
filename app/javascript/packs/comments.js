$(document).on('turbolinks:load', function() {

  $('.new-comment-link').on('click', function(e) {
    e.preventDefault()
    $(this).addClass('hidden')
    const commentableType = $(this).data('block')
    const commentableId = $(this).data('commentable-id')
    const formComment = $('.comments-' + commentableType + '-' + commentableId).find('form#new-comment-'+ commentableId)
    formComment.removeClass('hidden')
  })

  $('.comment-form-block').on('ajax:success', function(e) {
    const comment = e.detail[0][0].comment
    const elemClass = '.comments-' + comment.commentable_type.toLowerCase()+ '-' + comment.commentable_id 
    $('form#new-comment-' + comment.id).find('textarea').val('')
    $(elemClass).find('form').addClass('hidden')
    $(elemClass).find('.new-comment-link').removeClass('hidden')
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][1].errors
      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      })
    })
})
