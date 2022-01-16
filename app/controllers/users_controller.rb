class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @image = @user.image
    @tasks = @user.tasks
    @favorite_tasks = @user.favorite_tasks
  end
  
  def create
    @user = User.new(user_params) # userを作成。userの必要な情報のみ抜き取る
    if @user.save
      log_in @user # ユーザー登録中にログインを済ませておく
      flash[:success] = 'アプリへようこそ'
      redirect_to @user # @userのurlに遷都させる
    else
      render :new
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
        render :edit
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
