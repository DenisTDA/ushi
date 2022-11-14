$(document).on('turbolinks:load', function() {
  $('.question-block').on('click', function(e){
    $blockQ = $('.question-block').find('.vote-block')
  })

  $('.answers').on('click', function(e){
    const idElem = $(e.target).attr('data-id')
    if ($.isNumeric(idElem)) { $blockA = $('#answer-block-'+idElem).find('.vote-block') }
  })
  
  $('.question-block').on('ajax:success', function(e) {
    let vote = e.detail[0]
    let link = e.target.className.split(' ')[0]
    formatVote($blockQ, vote, link) 
  })

  $('.answers').on('ajax:success', function(e) {
    let vote = e.detail[0]
    let link = e.target.className.split(' ')[0]
    formatVote($blockA, vote, link) 
  })

  function formatVote(block, vote, link) {
    if (link === 'useful-link' || link === 'useless-link'){
      block.find('.useful-link').addClass('visually-hidden')
      block.find('.useless-link').addClass('visually-hidden')
      block.find('.reset-link').data('id', vote.voteable_id).prop('href', '/votes/' + vote.id)
      block.find('.reset-link').removeClass('visually-hidden')

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
    }
  }
})
