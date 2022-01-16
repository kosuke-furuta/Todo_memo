class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_inculuding_comma
  before_validation :set_nameless_name

  validates :user_id, presence: true
  validates :description, presence: true, length: { maximum: 140 }

  scope :recent, -> { order(created_at: :desc) }
  has_one_attached :image

  belongs_to :user
  # タスク → お気に入り
  has_many :favorites, dependent: :destroy
  

  # 既にお気に入りしていないか検証
  def favorited_by?(user)
    favorites.where(user_id: user).exists?
  end

  private

  def validate_name_not_inculuding_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  # コールバック 「名前なし」自動でつける
  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end
