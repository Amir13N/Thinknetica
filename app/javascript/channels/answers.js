$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  $('.answers').on('click', '.vote-answer-link', function(e){
    var rating = e.detail;
    var answerId = $(this).data('answerId');
    $('#answer-rating-' + answerId).html(rating);
    
    $('#answer-' + answerId + ' .vote-answer-link').each(function(i, el){
      $(el).hide();
    })
    $('#revote-answer-link-' + answerId).show();
  })

  $('.answer-actions').each(function(i, el){
    var voted = $(el).data('voted');

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

  $('.answers').on('click', '.revote-answer-link', function(e){
    var rating = e.detail;
    var answerId = $(this).data('answerId');
    $('#answer-rating-' + answerId).html(rating);

    $('#answer-' + answerId + ' .vote-answer-link').each(function(i, el){
      $(el).show();
    })
    $(this).hide();
  })
})