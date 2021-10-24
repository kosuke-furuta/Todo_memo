# メインのサンプルユーザーを1人作成する
User.create!(name: "吉田 麻也",
             email: "maya@example.jp",
             password: "password",
             password_confirmation: "password",
             admin: true,
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