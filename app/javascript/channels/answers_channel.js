import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
 // if(!document.querySelector('.questions')) { clearChannels() }
  clearChannels(this.answer_subscription)

  const question_id = $('.question-block').data('question-id')

  this.answer_subscription = consumer.subscriptions.create({ channel: "AnswersChannel", question_id: question_id }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected to the answers channel of th question-'+ question_id)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('disconnected...')
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if ( gon.user_id !== data.answerAuthorId){
        formatHtml(data.answerId, data.answer)
      }
    }
  })

  function clearChannels(subscription) {
    if (subscription){
      consumer.subscriptions.remove(subscription)
      console.log("unsubing")
    }
  }

  function formatHtml(answerId, body){
    $('.answers').append("<span id= 'answer-block-"+ answerId+ "'/>" )
    $('#answer-block-'+ answerId)
      .append("<div class= 'hstack.gap-2 border border-info m-1' > <i>" 
        + body + "</i></div>")
  }
})

