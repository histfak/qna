$ ->
  App.cable.subscriptions.create('CommentsChannel', {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      if data.comment.user_id != gon.user_id
        if data.comment.commentable_type == 'Answer'
          commentsList = $(".answer-" + data.comment.commentable_id + " .answer-comments")
          commentsList.append('<p>Comments:</p>')
          commentsList.append ->
            return '<div class="comment-' + data.comment.id + '"></div>';
          inner = $(".comment-" + data.comment.id)
          inner.wrapInner('<p>' + data.comment.body + '</p>')
        if data.comment.commentable_type == 'Question'
          commentsList = $(".question-comments")
          commentsList.append('<p>Comments:</p>')
          commentsList.append ->
            return '<div class="comment-' + data.comment.id + '"></div>';
           inner = $(".comment-" + data.comment.id)
           inner.wrapInner('<p>' + data.comment.body + '</p>')
  })