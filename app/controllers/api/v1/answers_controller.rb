class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.all
    render json: @answers
  end
end
