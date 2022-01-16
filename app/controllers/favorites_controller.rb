class FavoritesController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    favorite = current_user.favorites.new(task_id: @task.id)
    favorite.save
  end

  def destroy
    @task = Task.find(params[:task_id])
    favorite = current_user.favorites.find_by(task_id: @task.id)
    favorite.destroy
  end
end
