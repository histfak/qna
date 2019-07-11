$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    $('.question-voting').on('ajax:success', function(e) {
        var voting = e.detail[0];
        $('.question-scores').html('Scores: ' + voting.scores);
    });
});
