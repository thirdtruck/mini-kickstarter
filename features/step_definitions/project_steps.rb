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

Given(/^a project has been created$/) do
  @db = MiniKickstarterDB.new(':memory:')

  steps %{
    a project with a valid name
    a valid target dollar amount
    the "project" command is invoked
  }
end

When(/^the "project" command is invoked$/) do
  mini_kickstarter = MiniKickstarter.new
  @command_response = mini_kickstarter.invoke(@db,
                                              "project",
                                              project_name: @project_name,
                                              target_dollar_amount: @target_dollar_amount)
end
