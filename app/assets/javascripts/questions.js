$(document).on('turbolinks:load', function () {
    $('.question').on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    $('.question-new-comment').on('click', '.comment-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var questionId = $(this).data('questionId');
        $('form#new-comment-' + questionId).removeClass('hidden');
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

    $('.question-new-comment').on('ajax:success', function(e) {
        var comment = e.detail[0];
        $('.question-comments').append('<p>Comments:</p>');
        $('.question-comments').append(function(){
            return '<div class=' + '"comment-' + comment.id + '"></div>';
        });
        $('.comment-' + comment.id).append('<p>' + comment.body + '</p>');
    });
});
