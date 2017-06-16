class Admin::QuestionsController < Admin::ApplicationController
  include QuestionsHelper

  def new
    @exam = exam_includes.find_by_id(params[:exam_id])
    @question = Question.new
  end

  def create
    @exam = exam_includes.find_by_id(params[:question][:exam_id])
    @question = Question.new(question_params)
    if @exam && @question.save
      flash[:success] = ["Multi select Question ID: #{@question.id} is created"]
      redirect_to new_admin_response_option_path(:question_id => @question.id)
    else
      flash.now[:danger] = @question.errors.full_messages
      render :new
    end
  end

  def edit
    @question = Question.find_by_id(params[:id])
    @exam = Exam.includes(:questions).find_by_id(@question.exam_id)
  end

  def update
    @question = Question.find_by_id(params[:id])
    if @question && @question.update(question_params)
      flash[:success] = ["Options for question ID: #{@question.id} has been updated."]
      redirect_path_for_update @question
    else
      flash[:danger] = @question.errors.full_messages
      redirect_to new_admin_response_option_path(:question_id => @question.id)
    end
  end

  def destroy
    store_referer
    question = Question.find_by_id(params[:id])
    if question && question.destroy
      flash[:success] = ["Multiple selection question ID: #{question.id} has been deleted"]
      redirect_to referer
    else
      flash[:danger] = question.errors.full_messages
      redirect_to referer
    end
  end

  private
  def question_params
    params.require(:question).permit(:exam_id, :text, {:response_options_attributes => [:text]}, :options)
  end
end