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
        if (voting.type !== 'reset')
            $('.question-voting-links').html('<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/questions/' + voting.id + '/reset">Reset</a></p>');
        else
            $('.question-voting-links').html(
                '<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/questions/' + voting.id + '/like">Like</a></p>\
                <p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/questions/' + voting.id + '/dislike">Dislike</a></p>'
            );
    });
});
