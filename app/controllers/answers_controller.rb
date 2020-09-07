class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %w[create]
  before_action :find_answer, only: %w[destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @answer.question, notice: "Your answer successfully created."
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Answer was destroyed"
    else
      flash[:alert] = "You can't destroy answer"
    end
    redirect_to question_path(@answer.question)
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
