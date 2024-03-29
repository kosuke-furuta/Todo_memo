# メインのサンプルユーザーを1人作成する
User.create!(name: "ゲスト ユーザー",
             email: "guest@example.com",
             password: "password",
             password_confirmation: "password",
             activated: true,
             activated_at: Time.zone.now)

# 追加のユーザーをまとめて生成する
30.times do |n|
 name = Gimei.unique.name.kanji
 email = "example_#{n+1}@example.co.jp"
 password = "password"
 User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end