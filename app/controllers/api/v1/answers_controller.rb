class Api::V1::AnswersController < Api::V1::BaseController
  load_and_authorize_resource

  def show
    render json: @answer
  end
end
