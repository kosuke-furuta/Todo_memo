class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def create
    task = Task.new(task_params)
    task.save!
    flash[:info] = "メモ「#{task.name} 」を登録しました。"
    redirect_to tasks_url
  end

  def update
    task = Task.find(params[:id])
    task.update!(task_params)
    flash[:info] = "メモ「#{task.name} 」を編集しました。"
    redirect_to tasks_url
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    flash[:indo] = "メモ「#{task.name}」を削除しました。"
    redirect_to tasks_url
  end
  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
