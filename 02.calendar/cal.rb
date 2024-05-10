#!/usr/bin/env ruby

require 'date'
require 'optparse'

# 今日の日付を取得する
today_date =  Date.today
date_params = {year: today_date.year, month: today_date.month, day: today_date.day}

# コマンドライン引数で指定された年と月を取得する
opt = OptionParser.new
cmd_params = {}

opt.on('-y [VAL]') {|v| v.to_i}
opt.on('-m [VAL]') {|v| v.to_i}

opt.parse!(ARGV, into: cmd_params)

# date_paramsにコマンドライン引数で取得した年と月を反映
unless cmd_params[:y] == nil
  if cmd_params[:y] < 1970 || 2100 < cmd_params[:y] # 年数が対応範囲内か確認する
    raise OutOfRangeError, "年数が範囲外です。1970年から2100年までの年数を指定してください。"
  end
  date_params[:year] = cmd_params[:y]
end
unless cmd_params[:m] == nil
  if cmd_params[:m] < 1 || 12 < cmd_params[:y] # 正しい月が入力されているか確認する
    raise InvalidRangeError, "正しい月を指定してください。"
  end
  date_params[:month] = cmd_params[:m]
end
