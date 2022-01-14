class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # params[:session]にはpasswod:、email:のハッシュが含まれる。
    # &. ぼっち演算子 if user && user.authenticate → if user&.authenticateに省略
    if user &.authenticate(params[:session][:password]) # 正しいパスワード (true && true) == true # authenticateは認証失敗時falseを返す
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) # チェックボックスがオンの時に'1'になる。オフの時に'0'になる
      redirect_back_or user
    else
      flash.now[:danger] = 'メールとパスワードの組み合わせが無効です。'
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
