require_relative 'mini_kickstarter'

# Separate out the command line interface code from the command code
# in order to keep concerns separated. Sets us up to use more advanced
# command option management code later, too, like named parameters.
class MiniKickstarterCLI
  def self.parse_and_invoke(db, original_arguments)
    arguments = original_arguments.compact
    command_name = arguments.shift # Shifting to simplify counting/indexing below

    command_params = case command_name

    when "project"
      raise MissingCommandParameterError if arguments.length < 2
      MiniKickstarter.new.invoke_project(db,
                                         project_name: arguments[0],
                                         target_dollar_amount: arguments[1])
    when "back"
      raise MissingCommandParameterError if arguments.length < 4
      MiniKickstarter.new.invoke_back(db,
                                      given_name: arguments[0],
                                      project_name: arguments[1],
                                      credit_card_number: arguments[2],
                                      backing_amount: arguments[3])
    when "list"
      raise MissingCommandParameterError if arguments.length < 1
      MiniKickstarter.new.invoke_list(db, project_name: arguments[0])
    when "backer"
      raise MissingCommandParameterError if arguments.length < 1
      MiniKickstarter.new.invoke_backer(db, given_name: arguments[0])
    else
      raise UnrecognizedCommandError, "Unrecognized command"
    end
  rescue MissingCommandParameterError => e
    "ERROR: Missing parameter(s)"
  rescue StandardError => e
    "ERROR: #{e.message}"
  end

  private

  class MissingCommandParameterError < StandardError
  end

  class UnrecognizedCommandError < StandardError
  end
end
