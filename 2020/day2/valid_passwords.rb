# frozen_string_literal: true

passwords = File.read('./passwords.txt').split("\n")
PASSWORD_REGEX = /(?<min>\d+)-(?<max>\d+) (?<letter>\w): (?<password>\w+)/.freeze

valid_passwords = passwords.select do |entry|
  matches = entry.match(PASSWORD_REGEX)
  occurences = matches[:password].count(matches[:letter])
  occurences >= matches[:min].to_i && occurences <= matches[:max].to_i
end.count

puts valid_passwords
