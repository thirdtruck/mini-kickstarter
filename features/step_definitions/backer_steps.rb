When(/^the "backer" command is invoked for backer "([^"]*)"$/) do |given_name|
  @db ||= MiniKickstarterDB.new(':memory:')

  mini_kickstarter = MiniKickstarter.new

  @command_response = mini_kickstarter.invoke(@db, "backer", given_name: given_name)
end
