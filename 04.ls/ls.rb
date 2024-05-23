# frozen_string_literal: true

entries = Dir.entries('.')

def except_hidden_file(entries)
  entries.reject { |entry| entry[0] == '.' }
end

entries = except_hidden_file(entries)

entries.sort.each do |entry|
  puts entry
end
