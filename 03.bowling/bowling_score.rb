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
    frame += 1
    throw = 1
  elsif throw == 1 && score_group[0..1].sum == 10 # スペア判定
    add_score += score_group[2]
    throw = 2
  else
    frame += 1 if throw == 2
    throw = (throw == 2 ? 1 : 2)
  end

  [add_score, frame, throw]
end

total = score_list.each_with_index.sum do |score, index|
  next score if frame == 10

  score_group = score_list[index, 3]
  add_score, frame, throw = update_game_state(frame, throw, score_group)

  add_score + score
end

puts total
