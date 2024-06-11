#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_CHUNK = 3
TAB_SPACE = 8

file_paths = Dir.entries('.')

opt = OptionParser.new
params = opt.getopts(ARGV, 'r')

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

file_paths = params['r'] ? file_paths.sort.reverse : file_paths.sort
file_paths = except_hidden_file(file_paths)

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
