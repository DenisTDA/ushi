$(document).on('turbolinks:load', function() {
  $('.question-block').on('click', function(e){
    $blockQ = $('.question-block').find('.vote-block')
  })

  $('.answers').on('click', function(e){
    $idElem = $(e.target).attr('data-id')
    if ($.isNumeric($idElem)) { $blockA = $('#answer-block-'+ $idElem).find('.vote-block') }
  })
  
  $('.question-block').on('ajax:success', function(e) {
    const vote = e.detail[0][0]
    const rating = e.detail[0][1].useful
    const ratingNegativ = e.detail[0][1].useless
    const link = e.target.className.split(' ')[0]
    formatVote($blockQ, vote, link, rating, ratingNegativ) 
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0]
      $.each(errors, function(index, value) {
        $('.question-errors').append('<p>' + value + '</p>')
      })
    })

  $('.answers').on('ajax:success', function(e) {
    const vote = e.detail[0][0]
    const rating = e.detail[0][1].useful
    const ratingNegativ = e.detail[0][1].useless
    const link = e.target.className.split(' ')[0]
    formatVote($blockA, vote, link, rating, ratingNegativ) 
  })
    .on('ajax:error', function(e) {
      let errors = e.detail[0][0]
      $.each(errors, function(index, value) {
        $('#answer-errors-'+ $idElem).append('<p>' + value + '</p>')
      })
    })

  function formatVote(block, vote, link, rating, ratingNeg) {
    block.parent().find('.rating-block').html('')
    if (link === 'useful-link' || link === 'useless-link'){
      block.find('.useful-link').addClass('visually-hidden')
      block.find('.useless-link').addClass('visually-hidden')
      block.find('.reset-link').data('id', vote.voteable_id).prop('href', '/votes/' + vote.id)
      block.find('.reset-link').removeClass('visually-hidden')
      block.parent().find('.rating-block').append('👍 '+ rating + ' | 👎' + ratingNeg )

      if (vote.useful == true) {
        block.find('.voted-sign').html("\u2705") 
      } else if (vote.useful == false) { 
        block.find('.voted-sign').html("\u26D4") 
      }

    } else if (link === 'reset-link'){
      block.find('.useful-link').removeClass('visually-hidden')
      block.find('.useless-link').removeClass('visually-hidden')
      block.find('.voted-sign').html("")
      block.find('.reset-link').addClass('visually-hidden')      
      block.parent().find('.rating-block').html('👍 '+ rating + ' | 👎' + ratingNeg)      
    }
  }
})
