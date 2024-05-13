#!/usr/bin/env ruby # rubocop:disable Style/FrozenStringLiteralComment

score_list = ARGV[0].split(',')

total = 0 # 合計得点を入力する変数
add_score = 0 # ストライク・スペアの際の加算得点を記録する変数
flame = [1, 1] # フレーム、何投目かを管理する変数
pre_score = 0 # 同フレームの前回のスコアを記録する変数
strike_spare_flag = 0 # 前フレームが通常、スペア、ストライクのいずれかを判定する変数

# スコアをint型に変換する
def convert_str2int(score_s)
  if score_s == 'X'
    10 # Xを10に置き換える
  else
    score_s.to_i
  end
end

# ストライク・スペアの時の加算得点を計算するプログラム
def cal_addscore(score, flag)
  if flag > 0 # rubocop:disable Style/NumericPredicate
    add_score = score # 得点を加算
    flag -= 1 # フラグの数を減らす
  else
    add_score = 0
  end
  return add_score, flag # rubocop:disable Style/RedundantReturn
end

# 得点加算部分の実装
score_list.each do |score_s|
  score_i = convert_str2int(score_s) # str型の数値をint型に変換する
  # 前フレームがスペアないしストライクかどうかを判定し、いずれかに該当する場合は得点を加算する
  add_score, strike_spare_flag = cal_addscore(score_i, strike_spare_flag)

  # 10フレーム目の処理を別で実装
  if flame[0] == 10
    total += add_score + score_i # 得点を加算
    next
  end

  # ストライクだった時の処理
  if score_s == 'X'
    # 前回がストライク・スペアの確認をする
    total += add_score + score_i
    flame[0] += 1 # フレームを更新
    strike_spare_flag = 2
    next
  end

  # 投球数、フレーム数の更新
  if flame[1] == 1 # 1投目
    flame[1] = 2
    pre_score = score_i
  else # 2投目
    strike_spare_flag = 1 if pre_score + score_i == 10 # スペアになるかを判定し、該当する場合はフラグを1にする
    flame[0] += 1
    flame[1] = 1
    pre_score = 0
  end

  # 得点を加算
  total += add_score + score_i
end

puts total
