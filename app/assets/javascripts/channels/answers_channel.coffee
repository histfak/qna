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
