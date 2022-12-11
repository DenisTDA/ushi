import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  clearChannels(this.questions_subscription)
  this.questions_subscription = consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log('Connected with questions...')
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("disconnected...")
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      $('.questions').append(data)
      $('.questions').find('a').last().remove()
      $('.questions').find('a').last().remove()
    }
  });

  function clearChannels(subscription) {
    if (subscription){
      consumer.subscriptions.remove(subscription)
      console.log("unsubing")
    }
  }
})
