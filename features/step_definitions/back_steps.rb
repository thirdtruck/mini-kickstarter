Given(/^a valid given name$/) do
  @given_name = "example"
end

Given(/^a valid credit card number$/) do
  # TODO: Use a number that passes Luhn-10 below
  @credit_card_number = "1234567890123456789"
end

Given(/^a valid backing amount$/) do
  @backing_amount = "9.95"
end

Given(/^a given name of "([^"]*)"$/) do |given_name|
  @given_name = given_name
end

Given(/^a credit card number of "([^"]*)"$/) do |credit_card_number|
  @credit_card_number = credit_card_number
end

Given(/^a backing amount of "([^"]*)"$/) do |backing_amount|
  @backing_amount = backing_amount
end
