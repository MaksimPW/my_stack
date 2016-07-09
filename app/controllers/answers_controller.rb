class AnswersController < BaseController
  before_action :set_question, except:[:show, :edit, :update, :destroy]
  before_action :set_answer, only:[:show, :edit, :update, :destroy]
  def index
    @answers = @question.answers
  end
  def show
  end
  def new
    @answer = Answer.new
  end
  def edit
  end
  def create    
    @answer = @question.answers.new(answer_params)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @question, notice:'Your answer successfully added.'
    else
      render :new
    end
  end
  def update
    if @answer.update! answer_params
      redirect_to question_path @answer.question, notice:'Your answer successfully updated'
    else
      render :edit
    end
  end

  def destroy  
    @question = @answer.question  
    if current_user == @answer.user     
      @answer.destroy
      redirect_to @question, notice:'Answer deleted'
    else
      redirect_to @question, notice:'You do not have ptropper rights'
    end
  end

  private
  def set_question
    @question = Question.find params[:question_id]
  end 

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, :user_id)
  end
end
