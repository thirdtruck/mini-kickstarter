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

When(/^the "project" command is invoked$/) do
  mini_kickstarter = MiniKickstarter.new
  @command_response = mini_kickstarter.invoke("project",
                                              project_name: @project_name,
                                              target_dollar_amount: @target_dollar_amount)
end
