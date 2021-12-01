# frozen_string_literal: true

lines = File.read('input.txt').split("\n\n")

lines.map do |line|
  line.gsub!("\n", ' ')
end

def required_fields(line)
  line.include?('byr:') &&
    line.include?('iyr:') &&
    line.include?('eyr:') &&
    line.include?('hgt:') &&
    line.include?('hcl:') &&
    line.include?('ecl:') &&
    line.include?('pid:')
end

def valid_birth_year?(line)
  !(/byr:\s?(19[2-9][0-9]|200[0-2])/ =~ line).nil?
end

def valid_issue_year?(line)
  !(/iyr:\s?(201[0-9]|2020)/ =~ line).nil?
end

def valid_expiration_year?(line)
  !(/eyr:\s?(202[0-9]|2030)/ =~ line).nil?
end

def valid_height?(line)
  !(/hgt:\s?(1[5-8][0-9]|19[0-3])cm|(59|6[0-9]|7[0-6])in/ =~ line).nil?
end

def valid_hair_color?(line)
  !(/hcl:\s?#[0-9,a-f]{6}/ =~ line).nil?
end

def valid_eye_color?(line)
  !(/ecl:\s?(amb|blu|brn|gry|grn|hzl|oth)/ =~ line).nil?
end

def valid_passport_id?(line)
  !(/pid:\s?\d{9}\b/ =~ line).nil?
end

passports = lines.select do |line|
  required_fields(line) &&
    valid_birth_year?(line) &&
    valid_issue_year?(line) &&
    valid_expiration_year?(line) &&
    valid_height?(line) &&
    valid_hair_color?(line) &&
    valid_eye_color?(line) &&
    valid_passport_id?(line)
end

puts passports.count
