#!/usr/bin/env ruby
# frozen_string_literal: true

frame = 1
throw = 1

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

def update_game_state(frame, throw, score_group)
  add_score = 0
  if throw == 1 && score_group[0] == 10 # ストライク判定
    add_score += score_group[1..2].sum
  end
  if throw == 1 && score_group[0..1].sum == 10 # スペア判定
    add_score += score_group[2]
  end

  add_score
end

total = score_list.each_with_index.sum do |score, index|
  score_group = score_list[index, 3]
  if frame == 10
    next score
  else
    add_score, frame, throw = update_game_state(frame, throw, score_group)
  end

  if throw == 1 && score == 10 || throw == 2
    frame += 1
    throw = 1
  else
    throw = 2
  end

  add_score + score
end

puts total
