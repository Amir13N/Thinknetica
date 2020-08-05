import consumer from './consumer'

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create('CommentsChannel', {
    connected(){
      this.perform('follow');
    },

    received(data){
      $('.comments').append(data);
    }
  })
})