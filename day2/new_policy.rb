# frozen_string_literal: true

passwords = File.read('./passwords.txt').split("\n")
PASSWORD_REGEX = /(?<min>\d+)-(?<max>\d+) (?<letter>\w): (?<password>\w+)/.freeze

valid_passwords = passwords.select do |entry|
  matches = entry.match(PASSWORD_REGEX)

  min = matches[:min].to_i
  max = matches[:max].to_i
  letter = matches[:letter]
  password = matches[:password]

  (password.chars[min - 1] == letter) ^ (password.chars[max - 1] == letter)
end.count

puts valid_passwords
