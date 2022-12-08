import consumer from "./consumer"
$(document).on('turbolinks:load', function() {
  clearChannels(this.comment_subscription)

  const question_id = $('.question-block').data('question-id')

  this.comment_subscription = consumer.subscriptions.create({ channel: "CommentChannel", question_id: question_id }, {
    connected() {
      console.log('Connected with comment_channel_' + question_id)
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log('desconnected comment_channel_' + question_id)
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      if (data.comment !== null){
        formatHtml(data.comment, data.email, data.commentableType, data.commentableId )
      }
    }
  })

  function clearChannels(subscription) {
    if (subscription){
      consumer.subscriptions.remove(subscription)
      console.log("unsubing")
    }
  }

  function formatHtml(comment, email, type, id){
    let commentBlock = $('<div>').attr({ 'class': 'comment-block m-2 col-md-10 border border-secondary' })
    let time = new Date()
    commentBlock.append('<i>' + email + ' : ' + time + '</i>' )
    commentBlock.append('<p>' + comment + '</p>')
    const elemClass = '.comments-' + type + '-' + id 
    $(elemClass).find('.comments').prepend(commentBlock)
  }
})
