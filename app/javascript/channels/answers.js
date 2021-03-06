import consumer from './consumer'

$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('.answers').on('click', '.delete-answer-file', function(e) {
    var answerId = $(this).data('answerId');
    $('.answer-file-' + answerId).hide();
  })

  var bestAnswerId = $('.answers').data('bestAnswerId');
  $('#best-answer-link-' + bestAnswerId).hide();
  $('.answers').prepend($('#answer-' + bestAnswerId));

  $('.answers').on('ajax:success', '.vote-answer-link', function(e){
    var rating = e.detail[0];
    var answerId = $(this).closest('.answer-actions').data('answerId');
    $('#answer-rating-' + answerId).html(rating);
    
    $('#answer-' + answerId + ' .vote-answer-link').each(function(i, el){
      $(el).hide();
    })
    $('#revote-answer-link-' + answerId).show();
  })

  $('.answer-actions').each(function(){
    var voted = $(this).data('voted');

    if(voted){
      $(this).find('.revote-answer-link').show();
      $(this).find('.vote-against-answer-link').hide();
      $(this).find('.vote-for-answer-link').hide();
    }
    else{
      $(this).find('.revote-answer-link').hide();
      $(this).find('.vote-against-answer-link').show();
      $(this).find('.vote-for-answer-link').show();
    }
  })

  $('.answers').on('ajax:success', '.revote-answer-link', function(e){
    var rating = e.detail[0];
    var answerId = $(this).closest('.answer-actions').data('answerId');
    $('#answer-rating-' + answerId).html(rating);

    $('#answer-' + answerId + ' .vote-answer-link').each(function(i, el){
      $(el).show();
    })
    $(this).hide();
  })

  consumer.subscriptions.create('AnswersChannel', {
    connected(){
      var questionId = window.location.pathname.split('/')[2]
      this.perform('follow', {question_id: questionId});
    },

    received(data){
      if (gon.user_id != data['user_id']){
        $('.answers').append('<p>' + data['answer'] + '</p>');
      }
    }
  })
})