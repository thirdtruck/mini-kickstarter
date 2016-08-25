require 'credit_card'

class MiniKickstarter
  include CreditCard

  # TODO: Move checks into the option parser. Take only pre-vetted input.
  NUMERIC = /\A[0-9]+\z/
  ALPHANUMERIC_WITH_UNDERSCORES_DASHES = /\A[[:alnum:]_-]*[[:alnum:]]+[[:alnum:]_-]*\z/
  JUST_DOLLARS_AND_CENTS = /\A([1-9][0-9]*|[0-9])\.[0-9]{2}\z/

  def invoke(db, command_name, command_params)
    # TODO: Compile all errors before reporting instead of reporting only the first match. Better UX.
    case command_name
    when "project"
      invoke_project(db, command_params)
    when "back"
      invoke_back(db, command_params)
    when "list"
      invoke_list(db, command_params)
    else
      raise InvalidCommandParameterError, "Unrecognized command."
    end
  end

  class InvalidCommandParameterError < StandardError
  end

  private

  def invoke_project(db, command_params)
    project_name = command_params[:project_name]
    target_dollar_amount = command_params[:target_dollar_amount]

    # We could also capture the length requirements in the regular expression, but informative
    # error messages take priority.

    # Separating the amount requirements for a better error UX, too.

    # TODO: Do we need to use #mb_chars here? Doesn't seem to be the case.
    if project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Projects should be alphanumeric. Underscores or dashes are allowed."
    elsif project_name.length < 4 || project_name.length > 20
      raise InvalidCommandParameterError, "Projects should be no shorter than 4 characters but no longer than 20 characters."
    elsif target_dollar_amount =~ /\$/
      raise InvalidCommandParameterError, "Target dollar amount should not use the $ currency symbol."
    elsif target_dollar_amount !~ JUST_DOLLARS_AND_CENTS
      raise InvalidCommandParameterError, "Target dollar amount should include both dollars and cents."
    else
      db.create_project(project_name, dollars_and_cents_to_int(target_dollar_amount)) # TODO: Extract conversion method
      "Success"
    end
  end

  def invoke_back(db, command_params)
    given_name = command_params[:given_name]
    project_name = command_params[:project_name]
    credit_card_number_string = command_params[:credit_card_number]
    credit_card_number = credit_card_number_string.to_i
    backing_amount = command_params[:backing_amount]

    if given_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Given names should be alphanumeric. Underscores or dashes are allowed."
    elsif given_name.length < 4 || given_name.length > 20
      raise InvalidCommandParameterError, "Given names should be no shorter than 4 characters but no longer than 20 characters."
    elsif project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Projects should be alphanumeric. Underscores or dashes are allowed."
    elsif project_name.length < 4 || project_name.length > 20
      raise InvalidCommandParameterError, "Projects should be no shorter than 4 characters but no longer than 20 characters."
    elsif credit_card_number_string.length > 19
      raise InvalidCommandParameterError, "Credit card numbers should be no more than 19 characters."
    elsif credit_card_number_string !~ NUMERIC
      raise InvalidCommandParameterError, "Credit card numbers should contain only digits."
    elsif ! valid_credit_card_number?(credit_card_number)
      raise InvalidCommandParameterError, "Invalid credit card number." # TODO: What's a better error message?
    elsif backing_amount =~ /\$/
      raise InvalidCommandParameterError, "Target dollar amount should not use the $ currency symbol."
    elsif backing_amount !~ JUST_DOLLARS_AND_CENTS
      raise InvalidCommandParameterError, "Target dollar amount should include both dollars and cents."
    else
      begin
        db.back_project(project_name, given_name, credit_card_number, dollars_and_cents_to_int(backing_amount.to_f))
        "Success"
      rescue MiniKickstarterDB::ProjectAlreadyBackedError
        return raise InvalidCommandParameterError, "The credit card number has already been entered."
      end
    end
  end

  def invoke_list(db, command_params)
    project_name = command_params[:project_name]
    project = db.find_project_by_project_name(project_name)
    project_id = project[0]
    target_dollar_amount = project[2]

    backings = db.find_backings_by_project_id(project_id)

    backing_amounts = backings.map { |backing| backing[4] }

    unbacked_amount = target_dollar_amount - backing_amounts.reduce(:+)
    if unbacked_amount < 0
      unbacked_amount = 0
    end

    response = ''
    backings.each do |backing|
      backer_name = backing[1]
      backing_amount = backing[4]
      response << "-- #{backer_name} backed for $#{as_dollars_and_cents(backing_amount)}\n"
    end
    response << "#{project_name} needs $#{as_dollars_and_cents(unbacked_amount)} more dollars to be successful"
    response
  end

  def dollars_and_cents_to_int(amount_string)
    (amount_string.to_f * 100).to_i
  end

  def as_dollars_and_cents(amount)
    cents = amount % 100
    dollars = (amount - cents) / 100
    if cents == 0
      "#{dollars}"
    elsif dollars == 0
      "0.#{cents.to_s.rjust(2, '0')}"
    else
      "#{dollars}.#{cents.to_s.rjust(2, '0')}"
    end
  end
end
