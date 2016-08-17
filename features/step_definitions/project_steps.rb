Given(/^a project with a valid name$/) do
  @project_name = "example"
end

Given(/^a valid target dollar amount$/) do
  @target_dollar_amount = "1000000.00"
end

Given(/^a project called "([^"]*)"$/) do |project_name|
  @project_name = project_name
end

Given(/^a target dollar amount of "([^"]*)"$/) do |target_dollar_amount|
  @target_dollar_amount = target_dollar_amount
end

When(/^the "([^"]*)" command is invoked$/) do |command_name|
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^Mini Kickstarter should accept the command input$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^Mini Kickstarter should reject the command input$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
