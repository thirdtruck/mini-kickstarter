When(/^the "backer" command is invoked for backer "([^"]*)"$/) do |given_name|
  @db ||= MiniKickstarterDB.new(':memory:')

  @command_response = MiniKickstarter.new.parse_and_invoke(@db, ["backer", given_name])
end
