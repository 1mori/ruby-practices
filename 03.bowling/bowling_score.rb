#!/usr/bin/env ruby # rubocop:disable Style/FrozenStringLiteralComment

score_list = ARGV[0].split(',')

total = 0 # 合計得点を入力する変数
flame = [1, 1] # フレーム、何回目かを管理する変数
pre_score = 0 # 同フレームの前回のスコアを記録する変数
strike_spare_flag = 0 # 前フレームが通常、スペア、ストライクのいずれかを判定する変数

# 得点加算部分の実装
score_list.each do |score_s|
  add_score = 0 # ストライク・スペアの際の加算得点を記録する変数
  if score_s == 'X' # ストライクだった時の処理
    score = 10 # Xを10に置き換える
    # 前回がストライクないしスペアであった際には得点を+10する
    add_score = 10 if strike_spare_flag > 0 # rubocop:disable Style/NumericPredicate
    total += add_score + score # 得点を加算
    flame[0] += 1 # フレームを更新
    strike_spare_flag = 2
    next
  end
  # 1.前フレームがスペアないしストライクかどうかを判定し、いずれかに該当する場合は得点を加算する
  if strike_spare_flag > 0 # rubocop:disable Style/NumericPredicate
    add_score = score_s.to_i
    strike_spare_flag -= 1
  end

  # 3.投球数、フレーム数の更新
  if flame[1] == 1
    flame[1] = 2
    pre_score = score_s.to_i
  else
    strike_spare_flag = 1 if pre_score + score_s.to_i == 10 # スペアになるかを判定し、該当する場合はフラグを1にする
    flame[0] += 1
    flame[1] = 1
    pre_score = 0
  end
  total += add_score + score_s.to_i # 得点を加算
end

puts total
