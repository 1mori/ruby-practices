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