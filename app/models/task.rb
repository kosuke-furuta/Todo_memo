class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_inculuding_comma
  before_validation :set_nameless_name

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  private

  def validate_name_not_inculuding_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end

  # コールバック 「名前なし」自動でつける
  def set_nameless_name
    self.name = '名前なし' if name.blank?
  end
end