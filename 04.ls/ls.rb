# frozen_string_literal: true

entries = Dir.entries('.')

def sort_entries(entries)
  entries.sort
end

def except_hidden_file(entries)
  entries.reject { |entry| entry[0] == '.' }
end

entries = sort_entries(entries)
entries = except_hidden_file(entries)

entries.each do |entry|
  puts entry
end
