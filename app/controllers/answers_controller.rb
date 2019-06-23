class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer has been successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer has been deleted.'
    else
      redirect_to question_path(@answer.question), alert: 'You cannot delete a foreign answer.'
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
