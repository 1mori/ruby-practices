# frozen_string_literal: true

entries = Dir.entries('.')

entries.sort.each do |entry|
  next if entry[0] == '.'

  puts entry
end
