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
  file_mode + file_permissions
end

file_paths = Dir.entries('.').sort

opt = OptionParser.new
options = opt.getopts(ARGV, 'l')

file_paths = except_hidden_file(file_paths)

if options['l']
  file_paths.each do |file_path|
    file_stat = File.lstat(file_path)
    file_mode = convert_file_mode(file_stat)
    nlink = file_stat.nlink
    uid = Etc.getpwuid(file_stat.uid).name
    gid = Etc.getgrgid(file_stat.gid).name
    size = file_stat.size
    mtime = file_stat.mtime.strftime('%-m %d %H:%M')

    puts "#{file_mode}\t#{nlink}\t#{uid}\t#{gid}\t#{size}\t#{mtime}\t#{file_path}"
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
