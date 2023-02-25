$(document).on('turbolinks:load', function() {
  $('.vote-question').on('click', function(e){
    $blockQ = $('.question-block').find('.vote-block')
  })

  $('.answers').find('.vote-block').on('click', function(e){
    $idElem = $(e.target).attr('data-id')
    if ($idElem) { $blockA = $('#answer-block-'+ $idElem).find('.vote-block') }
  })
  
  $('.vote-question').find('.vote-block').on('ajax:success', function(e) {
    let voteQuestion = new Vote(e)
    voteQuestion.formatVote($blockQ) 
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0]
      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      })
    })

  $('.answers').find('.vote-block').on('ajax:success', function(e) {
    let voteAnswer = new Vote(e)
    voteAnswer.formatVote($blockA) 
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0]
      $.each(errors, function(index, value) {
        $('#answer-errors-'+ $idElem).append('<p>' + value + '</p>')
      })
    })
})
