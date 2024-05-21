#!/usr/bin/env ruby # rubocop:disable Style/FrozenStringLiteralComment

total = 0
flame = [1, 1]
pre_strike = false
running_strike = false
strike_spare_flag = 0

score_list = ARGV[0].split(',')
score_list = score_list.map { |score| score == 'X' ? 10 : score.to_i }

# ストライク・スペアの時の加算得点を計算するプログラム
def cal_addscore(score, flag, running_strike)
  if flag > 0 # rubocop:disable Style/NumericPredicate
    add_score = score # 得点を加算
    flag -= 1 # フラグの数を減らす
    add_score += score if running_strike
  else
    add_score = 0
  end
  [add_score, flag, false]
end

# 得点加算部分の実装
score_list.each_with_index do |score, ball_number|
  # 前フレームがスペアないしストライクかどうかを判定し、いずれかに該当する場合は得点を加算する
  add_score, strike_spare_flag, running_strike = cal_addscore(score, strike_spare_flag, running_strike)

  # 得点を合計得点に加算
  total += add_score + score

  next if flame[0] == 10

  # ストライクだった時の処理
  if score == 'X'
    flame[0] += 1 # フレームを更新
    strike_spare_flag = 2
    running_strike = true if pre_strike
    pre_strike = true
    next
  else
    pre_strike = false
  end

  # 投球数、フレーム数の更新
  if flame[1] == 1 # 1投目
    flame[1] = 2
  else # 2投目
    strike_spare_flag = 1 if score_list[ball_number - 1] + score == 10 # スペアになるかを判定し、該当する場合はフラグを1にする
    flame[0] += 1
    flame[1] = 1
  end
end

puts total
