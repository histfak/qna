class AnswersController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[show]
  before_action :load_question, only: %i[new create]
  before_action :load_answer, only: %i[show destroy update best]
  after_action :publish_answer, only: %i[create]

  authorize_resource

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
    @answer.destroy
    redirect_to question_path(@answer.question), notice: 'Your answer has been deleted.'
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def best
    @answer.set_best
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers_for_question_#{@question.id}",
                                 answer: @answer, links: @answer.links.to_a, files: @answer.files_params)
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [],
                                          links_attributes: [:name, :url, :_destroy])
  end
end
