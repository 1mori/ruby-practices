#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_CHUNK = 3
TAB_SPACE = 8

entries = Dir.entries('.')

def except_hidden_file(file_paths)
  file_paths.reject { |element| element[0] == '.' }
end

def shaped_file_paths(file_paths)
  return [] if file_paths.empty?

  num_rows = (file_paths.size.to_f / MAX_CHUNK).ceil
  sliced_paths = file_paths.each_slice(num_rows).to_a

  padded_slices = sliced_paths.map { |slice| slice + [nil] * (num_rows - slice.length) }
  padded_slices.transpose.map(&:compact)
end

entries = entries.sort
entries = except_hidden_file(entries)

shaped_array = shaped_file_paths(entries)
max_string_length = entries.map(&:length).max

shaped_array.each do |array_element|
  array_element.each do |element|
    tab_count = ((max_string_length - element.length) / TAB_SPACE.to_f).ceil + 1 # タブの挿入する回数を計算
    print element
    print "\t" * tab_count
  end
  puts
end
