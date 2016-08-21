Given(/^a valid given name$/) do
  @given_name = "example"
end

Given(/^a valid credit card number$/) do
  # TODO: Use a number that passes Luhn-10 below
  @credit_card_number = "79927398713"
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

Given(/^the credit card number "([^"]*)" has already been entered$/) do |credit_card_number|
  step %Q{a valid given name}
  step %Q{a project with a valid name}
  step %Q{a credit card number of "#{credit_card_number}"}
  step %Q{a valid backing amount}
  step %Q{the "back" command is invoked}
end

Given(/^a project has been backed$/) do
  step %Q{a project has been created}
  step %Q{a valid given name}
  step %Q{a valid credit card number}
  step %Q{a valid backing amount}
  step %Q{the "back" command is invoked}
end

When(/^the "back" command is invoked$/) do
  mini_kickstarter = MiniKickstarter.new
  begin
    @command_response = mini_kickstarter.invoke(@db,
                                                "back",
                                                given_name: @given_name,
                                                project_name: @project_name,
                                                credit_card_number: @credit_card_number,
                                                backing_amount: @backing_amount)
  rescue MiniKickstarter::InvalidCommandParameterError => e
    @command_response = "ERROR: #{e.message}"
  end
end
