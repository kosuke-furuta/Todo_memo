class TasksController < ApplicationController
  before_action :set_task, only: [:destroy]

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    @task = Task.find(params[:id])
    @user = @task.user
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))
    @task.image.attach(params[:task][:image])
    if @task.save
      flash[:info] = "メモ「#{@task.name} 」を登録しました。"
      redirect_to @task
    else
      render 'new'
    end
  end

  def update
    @task = Task.find(params[:id])
    @task.update!(task_params)
    flash[:info] = "メモ「#{@task.name} 」を編集しました。"
    redirect_to @task
  end

  def destroy
    @task.destroy
    flash[:info] = "メモ「#{@task.name}」を削除しました。"
    redirect_to controller: 'users', action: 'index'
  end
  private

  def task_params
    params.require(:task).permit(:name, :description, :image)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
