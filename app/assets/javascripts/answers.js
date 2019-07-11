$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('.answer-voting').on('ajax:success', function(e) {
        var voting = e.detail[0];
        $(this).find(">:first-child").html('Scores: ' + voting.scores);
    });
});
