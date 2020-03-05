$ ->
  answersList = $(".answers")

  App.cable.subscriptions.create('AnswersChannel', {
    connected: ->
      @perform 'follow', question_id: gon.question_id
    ,
    received: (data) ->
      if data.answer.user_id != gon.user_id
        answersList.append(JST['skims/answers/answer'] (data));
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow_answer', answer_ids: gon.answer_ids
    ,
    received: (data) ->
      if data.comment.user_id != gon.user_id
        commentsList = $(".answer-" + data.comment.commentable_id + " .answer-comments")
        commentsList.append('<p>Comments:</p>')
        commentsList.append ->
          return '<div class="comment-' + data.comment.id + '"></div>';
        inner = $(".comment-" + data.comment.id)
        inner.wrapInner('<p>' + data.comment.body + '</p>')
  })
