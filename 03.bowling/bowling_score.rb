#!/usr/bin/env ruby
# frozen_string_literal: true

total = 0
flame = [1, 1]

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

# ストライク・スペアの時の加算得点を計算するプログラム
def calculate_add_score(flame, score, score_list, ball_number)
  add_score = 0
  return add_score if flame[0] == 10

  add_score += score_list[ball_number + 1] + score_list[ball_number + 2] if flame[1] == 1 && score == 10 # ストライク判定
  add_score += score_list[ball_number + 1] if flame[1] == 2 && score_list[ball_number - 1] + score == 10 # スペア判定

  add_score
end

# 得点加算部分の実装
score_list.each_with_index do |score, ball_number|
  add_score = calculate_add_score(flame, score, score_list, ball_number)

  total += add_score + score

  # 投球数、フレーム数の更新
  if flame[0] == 10 # 10フレーム目はそれ以上フレーム数が更新されないので、個別に投球数を進める
    flame[1] += 1
  elsif flame[1] == 1 && score == 10
    flame[0] += 1 # ストライク処理
  elsif flame[1] == 1
    flame[1] = 2
  else
    flame[0] += 1
    flame[1] = 1
  end
end

puts total
