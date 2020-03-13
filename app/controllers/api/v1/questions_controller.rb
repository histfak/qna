class Api::V1::QuestionsController < Api::V1::BaseController
  load_and_authorize_resource

  def index
    render json: questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def update
    if @question.update(question_params)
      render json: @question
    else
      head :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    render json: questions
  end

  private

  def questions
    Question.all
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
