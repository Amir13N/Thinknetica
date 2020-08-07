import consumer from './consumer'

$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).show();
  })

  $('.questions').on('ajax:success', '.vote-question-link', function(e){
    var rating = e.detail[0];
    var questionId = $(this).closest('.question-actions').data('questionId');
    $('#question-rating-' + questionId).html(rating);
    
    $('#question-' + questionId + ' .vote-question-link').each(function(i, el){
      $(el).hide();
    })
    $('#revote-question-link-' + questionId).show();
  })

  $('.question-actions').each(function(){
    var voted = $(this).data('voted');

    if(voted){
      $(this).find('.revote-question-link').show();
      $(this).find('.vote-against-question-link').hide();
      $(this).find('.vote-for-question-link').hide();
    }
    else{
      $(this).find('.revote-question-link').hide();
      $(this).find('.vote-against-question-link').show();
      $(this).find('.vote-for-question-link').show();
    }
  })

  $('.questions').on('ajax:success', '.revote-question-link', function(e){
    var rating = e.detail[0];
    var questionId = $(this).closest('.question-actions').data('questionId');
    $('#question-rating-' + questionId).html(rating);

    $('#question-' + questionId + ' .vote-question-link').each(function(i, el){
      $(el).show();
    })
    $(this).hide();
  })

  consumer.subscriptions.create('QuestionsChannel', {
    connected(){
      this.perform('follow');
    },

    received(data){
      $('.questions').append('<p>' + data + '</p>');
    }
  })
})