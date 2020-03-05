$ ->
  questionsList = $(".questions-list")
  commentsList = $(".question-comments")

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      questionsList.append data
  })

  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow_question', question_id: gon.question_id
    ,
    received: (data) ->
      if data.comment.user_id != gon.user_id
        commentsList.append('<p>Comments:</p>')
        commentsList.append ->
          return '<div class="comment-' + data.comment.id + '"></div>';
        inner = $(".comment-" + data.comment.id)
        inner.wrapInner('<p>' + data.comment.body + '</p>')
  })
