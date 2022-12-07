import { data } from "jquery"
import consumer from "./consumer"
$(document).on('turbolinks:load', function() {
  clearChannels(this.comment_subscription)

  const commentable_id = $('.question-block').data('question-id')

  this.comment_subscription = consumer.subscriptions.create({ channel: "CommentChannel", commentable_id: commentable_id }, {
    connected() {
      console.log('Connected with comment_channel_' + commentable_id)
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data)
//      if ( gon.user_id !== data.answerAuthorId)
      if (data.comment !== null){
        formatHtml(data.comment, data.email)
      }
    }
  })

  function clearChannels(subscription) {
    if (subscription){
      consumer.subscriptions.remove(subscription)
      console.log("unsubing")
    }
  }

  function formatHtml(comment, email){
    let commentBlock = $('<div>').attr({ 'class': 'comment-block m-2 col-md-10 border border-secondary' })
    let time = new Date()
    commentBlock.append('<i>' + email + ' : ' + time + '</i>' )
    commentBlock.append('<p>' + comment + '</p>')
    $('.comments-question').find('.comments').prepend(commentBlock)
  }

})
