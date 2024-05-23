#!/usr/bin/env ruby
# frozen_string_literal: true

total = 0
frame = 1
throw = 1

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

# ストライク・スペアの時の加算得点を計算するプログラム
def calculate_add_score(throw, score, score_list, ball_number)
  add_score = 0
  add_score += score_list[ball_number + 1] + score_list[ball_number + 2] if throw == 1 && score == 10 # ストライク判定
  add_score += score_list[ball_number + 1] if throw == 2 && score_list[ball_number - 1] + score == 10 # スペア判定

  add_score
end

# 得点加算部分の実装
total = score_list.each_with_index.sum do |score, ball_number|
  add_score = if frame == 10
                0
              else
                calculate_add_score(throw, score, score_list, ball_number)
              end

  # 投球数、フレーム数の更新
  if frame == 10 # 10フレーム目はそれ以上フレーム数が更新されないので、個別に投球数を進める
    throw += 1
  elsif throw == 1 && score == 10
    frame += 1 # ストライク処理
  elsif throw == 1
    throw = 2
  else
    frame += 1
    throw = 1
  end

  add_score + score
end

puts total
