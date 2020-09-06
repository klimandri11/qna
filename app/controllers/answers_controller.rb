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
      redirect_to question_path(@answer.question), notice: "Answer was destroyed"
    else
      redirect_to question_path(@answer.question), alert: "You can't destroy answer"
    end
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
