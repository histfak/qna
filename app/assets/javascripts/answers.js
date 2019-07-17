$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('form.new-answer').on('ajax:success', function(e) {
        var answer = e.detail[0];

        $('.answers').append(JST['skims/answers/answer'] (answer));
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.answer-errors').append('<p>' + value + '</p>');
            });

        });

    $('.answer-voting').on('ajax:success', function(e) {
        var voting = e.detail[0];
        $(this).find(">:first-child").html('Scores: ' + voting.scores);
        if (voting.type !== 'reset')
            $(this).find(">:nth-child(2)").html('<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/reset">Reset</a></p>');
        else
            $(this).find(">:nth-child(2)").html(
                '<p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/like">Like</a></p>\
                <p><a data-type="json" data-remote="true" rel="nofollow" data-method="patch" href="/answers/' + voting.id + '/dislike">Dislike</a></p>'
            );
    });
});
