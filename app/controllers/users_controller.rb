class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated?
    @image = @user.image
    @tasks = @user.tasks
    @bookmark_tasks = @user.bookmark_tasks
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      @user.send_activation_email
      flash[:info] = "メールをチェックしてアカウントを有効にしてください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    @image = @user.image
  end

  def update
    @user = User.find(params[:id])
    if current_user == @user
      if @user.update(user_params)
        flash[:success] = "プロフィールを更新しました。"
        redirect_to @user
      else
        render 'edit'
      end
    else
      redirect_to root_url
    end
  end

  def index
    @users = User.page(params[:page]).per(10)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザーを削除しました。"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                     :password_confirmation, :image, { task_ids: [] }) 
  end

  # beforeアクション

  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
