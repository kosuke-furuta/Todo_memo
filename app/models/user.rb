class User < ApplicationRecord
  attr_accessor :remember_token # データベースに保存はしない、仮装の属性remmber_tokenを作成
  before_save :downcase_email
  # セキュアにハッシュ化したパスワードをデータベース内のpassword_digestという属性に保存できる
  # 仮想的な属性passwordとpassword_confirmationが使えるようになる。存在性と値が一致するかどうかのバリデーションも追加される
  # authenticateメソッドが使える (引数の文字列がパスワードと一致するとUserオブジェクトを、間違っているとfalseを返すメソッド) 
  has_secure_password

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 100 },
                                    uniqueness: true
  validates :password, presence: true, length: { minimum: 15 }, allow_nil: true

  has_many :tasks, dependent: :destroy
  # ユーザー → お気に入り
  has_many :bookmarks
  # 中間テーブル
  has_many :bookmark_tasks, through: :bookmarks, source: :task

  mount_uploader :image, ImageUploader

  has_one_attached :image

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64 # 長さ22のランダムな文字列を返す
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token # selfをつけることでローカル変数の作成を防ぐ
    update_attribute(:remember_digest, User.digest(remember_token)) # update_attributeメソッドで記憶ダイジェストを更新。検証を回避する効果。今回はユーザーのパスワードやパスワード確認にアクセスできないので、バリデーションを素通りさせなければいけない 
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(remember_token) # remember_digestとremember_tokenが同一かどうか調べるメソッド
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil) # user.forgetメソッドによってuser.rememberが取り消される
  end
end
