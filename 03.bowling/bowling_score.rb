#!/usr/bin/env ruby
# frozen_string_literal: true

frame = 1
throw = 1

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

total = score_list.each_with_index.sum do |score, index|
  next score if frame == 10

  score_group = score_list[index, 3]
  if throw == 1
    if score_group[0] == 10 # ストライク判定
      add_score = score_group[1..2].sum
      frame += 1
    else
      add_score = (score_group[0..1].sum == 10 ? score_group[2] : 0) # スペアかそうでないか判定
      throw = 2
    end
  else
    add_score = 0
    frame += 1
    throw = 1
  end

  add_score + score
end

puts total
