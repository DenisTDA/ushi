$(document).on('turbolinks:load', function() {
  $('.question-block').on('click', function(e){
    $blockQ = $('.question-block').find('.vote-block')
  })

  $('.answers').on('click', function(e){
    $idElem = $(e.target).attr('data-id')
    if ($.isNumeric($idElem)) { $blockA = $('#answer-block-'+ $idElem).find('.vote-block') }
  })
  
  $('.question-block').on('ajax:success', function(e) {
    let voteQuestion = new Vote(e)
    voteQuestion.formatVote($blockQ) 
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0]
      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      })
    })

  $('.answers').on('ajax:success', function(e) {
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
