require_relative 'mini_kickstarter'

class MiniKickstarterCLI
  def self.parse_and_invoke(db, arguments)
    command_name = arguments[0]

    command_params = case command_name

    when "project"
      {
        project_name: arguments[1],
        target_dollar_amount: arguments[2]
      }
    when "back"
      {
        given_name: arguments[1],
        project_name: arguments[2],
        credit_card_number: arguments[3],
        backing_amount: arguments[4]
      }
    when "list"
      {
        project_name: arguments[1]
      }
    when "backer"
      {
        given_name: arguments[1],
      }
    end

    begin
      MiniKickstarter.new.invoke(db, command_name, command_params)
    rescue StandardError => e
      "ERROR: #{e.message}"
    end
  end
end
