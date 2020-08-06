import consumer from './consumer'

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create('CommentsChannel', {
    connected(){
      var path = window.location.pathname.split('/');
      var commentableId = path[2];
      this.perform('follow', {commentable_id: commentableId});
    },

    received(data){
      if (gon.user_id != data['user_id']){
        $('.comments').append(data['partial']);
      }
    }
  })
})