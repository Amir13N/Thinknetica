import consumer from './consumer'

$(document).on('turbolinks:load', function(){
  consumer.subscriptions.create('CommentsChannel', {
    connected(){
      var questionId = window.location.pathname.split('/')[2];
      this.perform('follow', {question_id: questionId});
    },

    received(data){
      if (gon.user_id != data['user_id']){
        $('#' + data['commentable_name'] + '-comments-' + data['commentable_id']).append(data['partial']);
      }
    }
  })
})