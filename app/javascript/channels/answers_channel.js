import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  consumer.subscriptions.subscriptions.forEach(element => {
    element.unsubscribe()
  }); 

  const question_id = $('.question-block').data('question-id')

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: question_id }, {
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
      console.log(data)
      if ( gon.user_id !== data.answerAuthorId){
        $('.answers').append("<span id= 'answer-block-"+ data.answerId+ "'/>" )
        $('#answer-block-'+ data.answerId)
          .append("<div class= 'hstack.gap-2 border border-info m-1' > <i>" 
            + data.answer + "</i></div>")
      }
    }
  })
})

