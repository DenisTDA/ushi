export default class Vote {
  constructor(jsonData) {
    this.vote = jsonData.detail[0][0]
    this.ratingPos = jsonData.detail[0][1].useful
    this.ratingNeg = jsonData.detail[0][1].useless
    this.link = jsonData.target.className.split(' ')[0]
  }

  formatVote(block) {
    block.parent().find('.rating-block').html('')
    if (this.link === 'useful-link' || this.link === 'useless-link'){
      block.find('.useful-div').addClass('hidden')
      block.find('.useless-div').addClass('hidden')
      block.find('.reset-link').data('id', this.vote.voteable_id).prop('href', '/votes/' + this.vote.id)
      block.find('.reset-div').removeClass('hidden')
      block.parent().find('.rating-block').append('👍 '+ this.ratingPos + ' | 👎' + this.ratingNeg )

      if (this.vote.useful == true) {
        block.find('.voted-sign').html("\u2705") 
      } else if (this.vote.useful == false) { 
        block.find('.voted-sign').html("\u26D4") 
      }

    } else if (this.link === 'reset-link'){
      block.find('.useful-div').removeClass('hidden')
      block.find('.useless-div').removeClass('hidden')
      block.find('.voted-sign').html("")
      block.find('.reset-div').addClass('hidden')      
      block.parent().find('.rating-block').html('👍 '+ this.ratingPos + ' | 👎' + this.ratingNeg)      
    }
  }
}
