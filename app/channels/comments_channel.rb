class CommentsChannel < ApplicationCable::Channel
  def follow_question(data)
    stream_from "comments_for_question_#{data['question_id']}"
  end

  def follow_answer(data)
    data['answer_ids'].map do |id|
      stream_from "comments_for_answer_#{id}"
    end
  end
end
