# frozen_string_literal: true
BLUE = "\e[36m"
RESET = "\e[0m"

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

def directory?(element)
  if File.directory?(element)
    "#{BLUE}#{element}#{RESET}"
  else
    element
  end
end

entries = sort_entries(entries)
entries = except_hidden_file(entries)

max_string_length = entries.map(&:length).max + 1
shaped_array = split_array(entries, 3)

shaped_array.each do |array_element|
  array_element.each do |element|
    colored_length = directory?(element).length
    print directory?(element).ljust(max_string_length + colored_length - element.length)
  end
  print "\n"
end
