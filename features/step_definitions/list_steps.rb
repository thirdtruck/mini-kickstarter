When(/^the "list" command is invoked$/) do
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarter.new.parse_and_invoke(@db, ["list", @project_name])
end

Then(/^Mini Kickstarter should respond with:$/) do |expected_response|
  expect(@command_response).to eq(expected_response)
end

