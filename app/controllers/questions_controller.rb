class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answers = @question.answers
    @answer.links.new
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
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been deleted.'
    else
      redirect_to question_path(@question), alert: 'You cannot delete a foreign question.'
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: [:name, :url],
                                                    reward_attributes: [:title, :badge])
  end
end
