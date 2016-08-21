When(/^the "list" command is invoked$/) do
  mini_kickstarter = MiniKickstarter.new
  begin
    @command_response = mini_kickstarter.invoke(@db, "list", {})
  rescue MiniKickstarter::InvalidCommandParameterError => e
    @command_response = "ERROR: #{e.message}"
  end
end

Then(/^Mini Kickstarter should respond with:$/) do |expected_response|
  expect(@command_response).to eq(expected_response)
end

