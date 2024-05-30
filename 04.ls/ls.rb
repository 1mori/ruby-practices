#!/usr/bin/env ruby
# frozen_string_literal: true

TAB_SPACE = 8
TAB_SPACE.freeze

entries = Dir.entries('.')

def except_hidden_file(array)
  array.reject { |element| element[0] == '.' }
end

def split_array(array, max_length)
  num_rows = (array.size.to_f / max_length).ceil
  shaped_array = Array.new(num_rows) { [] }

  array.each_with_index do |element, index|
    row_index = index % num_rows
    shaped_array[row_index] << element
  end
  shaped_array
end

entries = entries.sort
entries = except_hidden_file(entries)

max_string_length = entries.map(&:length).max
shaped_array = split_array(entries, 3)

shaped_array.each do |array_element|
  array_element.each do |element|
    tab_count = ((max_string_length - element.length) / TAB_SPACE.to_f).ceil + 1 # タブの挿入する回数を計算
    print element
    print "\t" * tab_count
  end
  puts
end
