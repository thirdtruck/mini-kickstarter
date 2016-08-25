Given(/^a valid given name$/) do
  @given_name = "Jane"
end

Given(/^a valid credit card number$/) do
  @credit_card_number = "79927398713"
end

Given(/^a valid backing amount$/) do
  @backing_amount = "50.00"
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

Given(/^the credit card number "([^"]*)" has already been entered$/) do |credit_card_number|
  step %Q{a valid given name}
  step %Q{a project with a valid name}
  step %Q{a credit card number of "#{credit_card_number}"}
  step %Q{a valid backing amount}
  step %Q{the "back" command is invoked successfully}
end

Given(/^a project has been backed$/) do
  step %Q{a project has been created}
  step %Q{a valid given name}
  step %Q{a valid credit card number}
  step %Q{a valid backing amount}
  step %Q{the "back" command is invoked successfully}
end

Given(/^a project has been backed by "([^"]*)" for \$(.*) with card number (\d*)$/) do |given_name, backing_amount, credit_card_number|
  step %Q{a given name of "#{given_name}"}
  step %Q{a credit card number of "#{credit_card_number}"}
  step %Q{a backing amount of "#{backing_amount}"}
  step %Q{the "back" command is invoked successfully}
end

When(/^the "back" command is invoked$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarter.new.parse_and_invoke(@db, ["back",
                                                                 @given_name,
                                                                 @project_name,
                                                                 @credit_card_number,
                                                                 @backing_amount])
end

When(/^the "back" command is invoked successfully$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarter.new.parse_and_invoke(@db, ["back",
                                                                 @given_name,
                                                                 @project_name,
                                                                 @credit_card_number,
                                                                 @backing_amount])
end
