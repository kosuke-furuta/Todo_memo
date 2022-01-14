module SessionsHelper

  # 渡されたユーザーでログインする
  # cookieにハッシュ化したユーザーidを保存するメソッド
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id # cookies.signed[:user_id]で自動的にユーザーIDのcookiesの暗号が解除されて元に戻る
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  # 永続セッションの場合 session[:user_id]が存在すれば、一時セッションからユーザーを取得する
  # cookies[:user_id]が存在すれば、永続セッションからユーザーを取得する
  def current_user
    if (user_id = session[:user_id]) # ユーザーIDにセッションを代入した結果
      @current_user ||= User.find_by(id: user_id) # cookieに保存されたユーザーidを元にユーザーの情報を取得するメソッド
    # find_byを使いidを指定する。emailではなくidで検索することで、リクエスト内のdb問い合わせを最初の1回だけにしている
    # Userオブジェクトの論理値は常にtrueになる。@current_userに何も代入されてないときだけfind_byが呼び出しが実行され、無駄なデータベースの読み出しが行われなくなる
    elsif (user_id = cookies.signed[:user_id]) # 永続セッションからユーザーを取得
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token]) # ユーザーが存在かつ、永続セッションの中の記憶トークンとdbの値と一致する
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザーがカレントユーザーであればtrueを返す
  def current_user?(user)
    user && user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil? # 否定演算子なので、!を使用
  end

  # 永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id) # user_idのcookiesを削除 
    cookies.delete(:remember_token) # remember_tokenのcookiesを削除
  end

  # 現在のユーザーをログアウトする
  # ブラウザのcookieに保存されているユーザーidを削除するメソッド
  def log_out
    forget(current_user) # forgetメソッドをlog_outヘルパーメソッドから呼び出してる
    session.delete(:user_id) # セッションからユーザーIDを削除する
    @current_user = nil
  end

  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
