# frozen_string_literal: true

entries = Dir.entries('.')

def except_hidden_file(entries)
  entries.reject { |entry| entry[0] == '.' }
end

def sort_entries(entries)
  entries.sort
end

entries = except_hidden_file(entries)
entries = sort_entries(entries)

entries.each do |entry|
  puts entry
end
