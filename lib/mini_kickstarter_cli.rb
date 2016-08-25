require_relative 'mini_kickstarter'

class MiniKickstarterCLI
  def self.parse_and_invoke(db, original_arguments)
    arguments = original_arguments.compact
    command_name = arguments.shift # Shifting to simplify counting/indexing below

    command_params = case command_name

    when "project"
      raise MissingCommandParameterError if arguments.length < 2
      {
        project_name: arguments[0],
        target_dollar_amount: arguments[1]
      }
    when "back"
      raise MissingCommandParameterError if arguments.length < 4
      {
        given_name: arguments[0],
        project_name: arguments[1],
        credit_card_number: arguments[2],
        backing_amount: arguments[3]
      }
    when "list"
      raise MissingCommandParameterError if arguments.length < 1
      {
        project_name: arguments[0]
      }
    when "backer"
      raise MissingCommandParameterError if arguments.length < 1
      {
        given_name: arguments[0],
      }
    end

    begin
      MiniKickstarter.new.invoke(db, command_name, command_params)
    rescue StandardError => e
      "ERROR: #{e.message}"
    end
  rescue MissingCommandParameterError => e
    "ERROR: Missing parameter(s)"
  end

  class MissingCommandParameterError < StandardError
  end
end
