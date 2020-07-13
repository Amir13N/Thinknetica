$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).show();
  })

  var bestAnswerId = $('.answers').data('bestAnswerId');
  $('.answers').prepend($('#answer-' + bestAnswerId));
  $('#best-answer-link-' + bestAnswerId).hide();
})