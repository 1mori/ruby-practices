# frozen_string_literal: true

entries = Dir.entries('.')

def sort_entries(array)
  array.sort
end

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

entries = sort_entries(entries)
entries = except_hidden_file(entries)

max_string_length = entries.map(&:length).max
shaped_array = split_array(entries, 3)

entries.each do |entry|
  puts entry
end
