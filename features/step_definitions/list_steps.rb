When(/^the "list" command is invoked$/) do
  mini_kickstarter = MiniKickstarter.new
  @command_response = mini_kickstarter.invoke(@db, "list", {})
end

Then(/^Mini Kickstarter should respond with:$/) do |expected_response|
  expect(@command_response).to eq(expected_response)
end

