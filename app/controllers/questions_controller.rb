class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  after_action :publish_question, only: %i[create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    @answer.links.new
    @comments = @question.comments
    gon.question_id = @question.id
    gon.answer_ids = @question.answers.map { |answer| answer.id }
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question has been successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question has been deleted.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast('questions',
                                 ApplicationController.render(partial: 'questions/question_title',
                                                              locals: { question: @question }))
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: [:name, :url, :_destroy],
                                                    reward_attributes: [:title, :badge])
  end
end
