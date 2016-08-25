Given(/^a project with a valid name$/) do
  @project_name = "Awesome_Sauce"
end

Given(/^a valid target dollar amount$/) do
  @target_dollar_amount = "500.00"
end

Given(/^a project called "([^"]*)"$/) do |project_name|
  @project_name = project_name
end

Given(/^a target dollar amount of "([^"]*)"$/) do |target_dollar_amount|
  @target_dollar_amount = target_dollar_amount
end

Given(/^a project has been created$/) do
  step 'a project with a valid name'
  step 'a valid target dollar amount'
  step 'the "project" command is invoked successfully'
end

Given(/^a project called "([^"]*)" has been created with a target dollar amount of \$(.*)$/) do |project_name, target_dollar_amount|
  step %Q{a project called "#{project_name}"}
  step %Q{a target dollar amount of "#{target_dollar_amount}"}
  step %Q{the "project" command is invoked successfully}
end

When(/^the "project" command is invoked$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarterCLI.parse_and_invoke(@db, ["project", @project_name, @target_dollar_amount])
end

When(/^the "project" command is invoked successfully$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarterCLI.parse_and_invoke(@db, ["project", @project_name, @target_dollar_amount])
end
