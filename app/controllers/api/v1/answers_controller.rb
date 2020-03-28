class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  before_action :load_question, only: :create

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_resource_owner
    if @answer.save
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      render json: @answer
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @answer.destroy
    render json: @question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
