class Bookmark < ApplicationRecord
  # ユーザー → お気に入り 1:多
  belongs_to :user
  # タスク → お気に入り 1:多
  belongs_to :task
end
