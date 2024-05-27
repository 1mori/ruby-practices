#!/usr/bin/env ruby
# frozen_string_literal: true

frame = 1
throw = 1

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

# ストライク・スペアの時の加算得点を計算
def calculate_add_score(throw, score_group)
  add_score = 0
  add_score += score_group[1..2].sum if throw == 1 && score_group[0] == 10 # ストライク判定
  add_score += score_group[2] if throw == 1 && score_group[0..1].sum == 10 # スペア判定

  add_score
end

total = score_list.each_with_index.sum do |score, index|
  score_group = score_list[index, 3]
  add_score = if frame == 10
                next score
              else
                calculate_add_score(throw, score_group)
              end

  # 投球数、フレーム数の更新
  if throw == 1 && score == 10 || throw == 2
    frame += 1
    throw = 1
  else
    throw = 2
  end

  add_score + score
end

puts total
