class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update best]

  def show
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    if @answer.save
      flash.now[:notice] = 'Your answer has been successfully created.'
    else
      flash.now[:notice] = 'Something went wrong.'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer has been deleted.'
    else
      redirect_to question_path(@answer.question), alert: 'You cannot delete a foreign answer.'
    end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    @question = @answer.question
  end

  def best
    @answer.set_best if current_user.author_of?(@answer.question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: [:name, :url])
  end
end
