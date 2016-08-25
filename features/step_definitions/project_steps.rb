Given(/^a project with a valid name$/) do
  @project_name = "Awesome_Sauce"
end

Given(/^a valid target dollar amount$/) do
  @target_dollar_amount = "450.00"
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
  step 'the "project" command is invoked'
end

When(/^the "project" command is invoked$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  mini_kickstarter = MiniKickstarter.new
  begin
    @command_response = mini_kickstarter.invoke(@db,
                                                "project",
                                                project_name: @project_name,
                                                target_dollar_amount: @target_dollar_amount)
  rescue MiniKickstarter::InvalidCommandParameterError => e
    @command_response = "ERROR: #{e.message}"
  end
end
