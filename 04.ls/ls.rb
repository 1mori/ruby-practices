#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

MAX_CHUNK = 3
TAB_SPACE = 8

FILE_TYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => 'f',
  'link' => 'l',
  'socket' => 's'
}.freeze

FILE_MODE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

SPECIAL_MODE = [
  { bit: '4', index: 2, exec: 's', no_exec: 'S' },
  { bit: '2', index: 5, exec: 's', no_exec: 'S' },
  { bit: '1', index: 8, exec: 't', no_exec: 'T' }
].freeze

def except_hidden_file(file_paths)
  file_paths.reject { |element| element[0] == '.' }
end

def chunk_file_paths(file_paths, num_rows)
  return [] if file_paths.empty?

  file_paths.each_slice(num_rows).to_a
end

def transpose_chunks(sliced_paths, num_rows)
  padded_slices = sliced_paths.map { |slice| slice + [nil] * (num_rows - slice.length) }
  padded_slices.transpose.map(&:compact)
end

def convert_file_mode(file_stat)
  file_mode_octal = file_stat.mode.to_s(8).rjust(6, '0')
  file_mode = FILE_TYPE[file_stat.ftype].to_s
  file_permissions = file_mode_octal.slice(3..-1).chars.map { |char| FILE_MODE[char] }.join
  # 特殊権限の確認
  file_permissions = apply_special_modes(file_mode_octal[2], file_permissions) if file_mode_octal[2] != '0'
  file_mode + file_permissions
end

def apply_special_modes(special_modes, permissions)
  SPECIAL_MODE.each do |mode|
    if special_modes == mode[:bit]
      permissions[mode[:index]] == 'x' ? mode[:exec] : mode[:no_exec]
    end
  end
  permissions
end

def format_file_mode(file_path)
  file_stat = File.lstat(file_path)
  {
    file_mode: convert_file_mode(file_stat),
    nlink: file_stat.nlink.to_s,
    uid: Etc.getpwuid(file_stat.uid).name,
    gid: Etc.getgrgid(file_stat.gid).name,
    size: file_stat.size.to_s,
    mtime: file_stat.mtime.strftime('%-m %d %H:%M'),
    file_path:,
    blocks: file_stat.blocks
  }
end

def calclate_max_string_modes(file_modes)
  {
    nlink: file_modes.map { |file_mode| file_mode[:nlink].size }.max,
    uid: file_modes.map { |file_mode| file_mode[:uid].size }.max,
    gid: file_modes.map { |file_mode| file_mode[:gid].size }.max,
    size: file_modes.map { |file_mode| file_mode[:size].size }.max,
    mtime: file_modes.map { |file_mode| file_mode[:mtime].size }.max
  }
end

file_paths = Dir.entries('.').sort

opt = OptionParser.new
options = opt.getopts(ARGV, 'l')

file_paths = except_hidden_file(file_paths)

if options['l']
  file_modes = file_paths.map { |file_path| format_file_mode(file_path) }
  total_blocks = file_modes.map { |file_mode| file_mode[:blocks] }.sum

  puts "total #{total_blocks}"

  max_string_modes = calclate_max_string_modes(file_modes)
  file_modes.each do |file_mode|
    file_mode_print = [
      file_mode[:file_mode],
      file_mode[:nlink].rjust(max_string_modes[:nlink]),
      file_mode[:uid].ljust(max_string_modes[:uid]),
      '',
      file_mode[:gid].ljust(max_string_modes[:gid]),
      file_mode[:size].rjust(max_string_modes[:size]),
      file_mode[:mtime].ljust(max_string_modes[:mtime]),
      file_mode[:file_path]
    ].join(' ')
    puts file_mode_print
  end
else
  num_rows = (file_paths.size.to_f / MAX_CHUNK).ceil
  sliced_paths = chunk_file_paths(file_paths, num_rows)
  shaped_file_paths_array = transpose_chunks(sliced_paths, num_rows)

  max_string_length = file_paths.map(&:length).max

  shaped_file_paths_array.each do |array_element|
    array_element.each do |element|
      tab_count = ((max_string_length - element.length) / TAB_SPACE.to_f).ceil + 1 # タブの挿入する回数を計算
      print element
      print "\t" * tab_count
    end
    puts
  end
end
