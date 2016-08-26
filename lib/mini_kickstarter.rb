require_relative 'credit_card'

class MiniKickstarter
  include CreditCard

  # TODO: Separate out reporting code from non-reporting code.
  # TODO: Refactor to be more east-oriented.
  # (http://www.saturnflyer.com/blog/jim/2015/02/10/the-4-rules-of-east-oriented-code-rule-1/)

  # Some of these commands could get away with positional arguments instead of named ones,
  # but maintaining a consistent interface takes priority.

  def invoke_project(db, command_params)
    project_name = command_params[:project_name]
    target_dollar_amount = command_params[:target_dollar_amount]

    # We could also capture the length requirements in the regular expression, but informative
    # error messages take priority.

    # Separating the amount requirements for a better error UX, too.

    # TODO: Do we need to use #mb_chars here? Doesn't seem to be the case.
    if project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Projects should be alphanumeric. Underscores or dashes are allowed"
    elsif project_name.length < 4 || project_name.length > 20
      raise InvalidCommandParameterError, "Projects should be no shorter than 4 characters but no longer than 20 characters"
    elsif target_dollar_amount =~ /\$/
      raise InvalidCommandParameterError, "Target dollar amount should not use the $ currency symbol"
    elsif target_dollar_amount !~ JUST_DOLLARS_AND_CENTS
      raise InvalidCommandParameterError, "Target dollar amount is invalid"
    else
      amount_as_int = dollars_and_cents_to_int(target_dollar_amount)
      db.create_project(project_name, amount_as_int)
      "Added #{project_name} project with target of $#{as_dollars_and_cents(amount_as_int)}"
    end
  end

  def invoke_back(db, command_params)
    given_name = command_params[:given_name]
    project_name = command_params[:project_name]
    credit_card_number_string = command_params[:credit_card_number]
    credit_card_number = credit_card_number_string.to_i
    backing_amount = command_params[:backing_amount]

    if given_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Given names should be alphanumeric. Underscores or dashes are allowed"
    elsif given_name.length < 4 || given_name.length > 20
      raise InvalidCommandParameterError, "Given names should be no shorter than 4 characters but no longer than 20 characters"
    elsif project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      raise InvalidCommandParameterError, "Projects should be alphanumeric. Underscores or dashes are allowed"
    elsif project_name.length < 4 || project_name.length > 20
      raise InvalidCommandParameterError, "Projects should be no shorter than 4 characters but no longer than 20 characters"
    elsif credit_card_number_string.length > 19
      raise InvalidCommandParameterError, "This card is invalid"
    elsif credit_card_number_string !~ NUMERIC
      raise InvalidCommandParameterError, "This card is invalid"
    elsif ! valid_credit_card_number?(credit_card_number)
      raise InvalidCommandParameterError, "This card is invalid" # TODO: What's a better error message?
    elsif backing_amount =~ /\$/
      raise InvalidCommandParameterError, "Target dollar amount should not use the $ currency symbol"
    elsif backing_amount !~ JUST_DOLLARS_AND_CENTS
      raise InvalidCommandParameterError, "Target dollar amount is invalid"
    else
      begin
        amount_as_int = dollars_and_cents_to_int(backing_amount)
        db.back_project(project_name, given_name, credit_card_number, amount_as_int)
        "#{given_name} backed project #{project_name} for $#{as_dollars_and_cents(amount_as_int)}"
      rescue MiniKickstarterDB::ProjectAlreadyBackedError
        return raise InvalidCommandParameterError, "That card has already been added by another user!"
      end
    end
  end

  def invoke_list(db, command_params)
    project_name = command_params[:project_name]
    project = db.find_project_by_project_name(project_name)
    project_id = project[:id]
    target_dollar_amount = project[:target_dollar_amount]

    backings = db.find_backings_by_project_id(project_id)

    backing_amounts = backings.map { |backing| backing[:backing_dollar_amount] }

    unbacked_amount = target_dollar_amount - backing_amounts.reduce(:+)

    response = ''

    backings.each do |backing|
      backer_name = backing[:given_name]
      backing_amount = backing[:backing_dollar_amount]
      response << "-- #{backer_name} backed for $#{as_dollars_and_cents(backing_amount)}\n"
    end

    if unbacked_amount > 0
      response << "#{project_name} needs $#{as_dollars_and_cents(unbacked_amount)} more dollars to be successful"
    else
      response << "#{project_name} is successful!"
    end

    response
  end

  def invoke_backer(db, command_params)
    given_name = command_params[:given_name]

    names_and_amounts = db.find_project_names_backing_dollar_amounts_by_given_name(given_name)

    response = names_and_amounts.map do |nam|
      "-- Backed #{nam[:project_name]} for $#{as_dollars_and_cents(nam[:backing_dollar_amount])}"
    end.join("\n")

    response
  end

  class InvalidCommandParameterError < StandardError
  end

  private

  # TODO: Move checks into the option parser. Take only pre-vetted input.
  NUMERIC = /\A[0-9]+\z/
  ALPHANUMERIC_WITH_UNDERSCORES_DASHES = /\A[[:alnum:]_-]*[[:alnum:]]+[[:alnum:]_-]*\z/
  JUST_DOLLARS_AND_CENTS = /\A(0|[1-9][0-9]*|([1-9][0-9]*|[0-9])\.[0-9]{2})\z/

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
