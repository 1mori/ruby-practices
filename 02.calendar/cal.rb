#!/usr/bin/env ruby

require 'date'
require 'optparse'

today_date = Date.today

opt = OptionParser.new
cmd_params = {}

opt.on('-y [VAL]') {|v| v.to_i}
opt.on('-m [VAL]') {|v| v.to_i}
opt.parse!(ARGV, into: cmd_params)

target_params = { year: today_date.year, month: today_date.month }

if cmd_params[:y] # 年が指定されているとき
  if cmd_params[:y] < 1970 || 2100 < cmd_params[:y]
    raise OutOfRangeError, "年数が範囲外です。1970年から2100年までの年数を指定してください。"
  end
  target_params[:year] = cmd_params[:y]
end

if cmd_params[:m] # 月が指定されているとき
  if cmd_params[:m] < 1 || 12 < cmd_params[:m]
    raise InvalidRangeError, "正しい月を指定してください。"
  end
  target_params[:month] = cmd_params[:m]
end

first_date = Date.new(target_params[:year], target_params[:month], 1)
last_date = Date.new(target_params[:year], target_params[:month], -1)


# カレンダーの表示部分を作成する
# x月 xxxxの出力、曜日の出力
puts "      #{target_params[:month]}月 #{target_params[:year]}"
puts "日 月 火 水 木 金 土"

# 1日目までの左上の空白を出力
first_date.wday.times { print " " * 3 }

# 日にちの出力
(first_date..last_date).each do |current_date|
  if current_date == today_date
    print "\e[7m#{current_date.day.to_s.rjust(2)}\e[0m" # 今日の日付の色を反転
  else
    print current_date.day.to_s.rjust(2)
  end
  if current_date.saturday? # 曜日リセット
    print "\n"
  else
    print " "
  end
end
print "\n" unless last_date.saturday? # 最後の行の改行
