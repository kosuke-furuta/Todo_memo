class BookmarksController < ApplicationController
  def create
    @task = Task.find(params[:task_id])
    bookmark = current_user.bookmark.new(task_id: @task.id)
    bookmark.save
  end

  def destroy
    @task = Task.find(params[:task_id])
    bookmark = current_user.bookmark.find_by(task_id: @task.id)
    bookmark.destroy
  end
end
