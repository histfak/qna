$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
        $('.new-answer').hide();
    });

    $('.answer-new-comment').on('click', '.comment-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#new-comment-' + answerId).removeClass('hidden');
    });

    $('.answer-voting').on('ajax:success', function(e) {
        var voting = e.detail[0];
        $(this).find('>:first-child').html('Scores: ' + voting.scores);
        if (voting.type !== 'reset')
            $(this).find('>:nth-child(2)').html('<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/reset">Reset</a></p>');
        else
            $(this).find('>:nth-child(2)').html(
                '<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/like">Like</a></p>\
                <p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/dislike">Dislike</a></p>'
            );
    });

    $('.answer-new-comment').on('ajax:success', function(e) {
        var comment = e.detail[0];
        $('.answer-comments').append('<p>Comments:</p>');
        $('.answer-comments').append(function(){
            return '<div class=' + '"comment-' + comment.id + '"></div>';
        });
        $('.comment-' + comment.id).append('<p>' + comment.body + '</p>');
    });
});
