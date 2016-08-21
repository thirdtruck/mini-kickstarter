Then(/^Mini Kickstarter should accept the command input$/) do
  expect(@command_response).to eq('Success')
end

Then(/^Mini Kickstarter should respond with "([^"]*)"$/) do |message|
  expect(@command_response).to eq(message)
end
