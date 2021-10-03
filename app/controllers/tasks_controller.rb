class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks.order(created_at: :desc)
  end

  def show
    @user = @task.user
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params.merge(user_id: current_user.id))

    if @task.save
      flash[:info] = "メモ「#{@task.name} 」を登録しました。"
      redirect_to @task
    else
      render 'new'
    end
  end

  def update
    task.update!(task_params)
    flash[:info] = "メモ「#{task.name} 」を編集しました。"
    redirect_to tasks_url
  end

  def destroy
    task.destroy
    flash[:indo] = "メモ「#{task.name}」を削除しました。"
    redirect_to tasks_url
  end
  private

  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = current_user.tasks.find(params[:id])
  end
end
