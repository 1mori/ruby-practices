# !/usr/bin/env ruby # rubocop:disable Style/FrozenStringLiteralComment

score_list = ARGV[0].split(',')

total = 0 # 合計得点を入力する変数
score_list.each do |score|
  score = '10' if score == 'X'
  total += score.to_i
end

p total
