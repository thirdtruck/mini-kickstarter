Then(/^Mini Kickstarter should accept the command input$/) do
  expect(@command_response).to eq('Success')
end

Then(/^Mini Kickstarter should reject the command input$/) do
  puts @command_response
  expect(@command_response).to match(/^ERROR:/)
end

Then(/^Mini Kickstarter should respond to the command input with the message "([^"]*)"$/) do |message|
  puts @command_response
  expect(@command_response).to eq(message)
end
