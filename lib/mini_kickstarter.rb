class MiniKickstarter
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
      "ERROR: Unrecognized command."
    end
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
      "ERROR: Projects should be alphanumeric. Underscores or dashes are allowed."
    elsif project_name.length < 4 || project_name.length > 20
      "ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters."
    elsif target_dollar_amount =~ /\$/
      "ERROR: Target dollar amount should not use the $ currency symbol."
    elsif target_dollar_amount !~ JUST_DOLLARS_AND_CENTS
      "ERROR: Target dollar amount should include both dollars and cents."
    else
      "Success"
    end
  end

  def invoke_back(db, command_params)
    given_name = command_params[:given_name]
    project_name = command_params[:project_name]
    credit_card_number = command_params[:credit_card_number]
    backing_amount = command_params[:backing_amount]

    if given_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      "ERROR: Given names should be alphanumeric. Underscores or dashes are allowed."
    elsif given_name.length < 4 || given_name.length > 20
      "ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters."
    elsif project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES
      "ERROR: Projects should be alphanumeric. Underscores or dashes are allowed."
    elsif project_name.length < 4 || project_name.length > 20
      "ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters."
    elsif credit_card_number.length > 19
      "ERROR: Credit card numbers should be no more than 19 characters."
    elsif credit_card_number !~ NUMERIC
      "ERROR: Credit card numbers should contain only digits."
    elsif ! valid_luhn_10_sequence?(credit_card_number.split(//).map(&:to_i))
      "ERROR: Invalid credit card number." # TODO: What's a better error message?
    elsif backing_amount =~ /\$/
      "ERROR: Target dollar amount should not use the $ currency symbol."
    elsif backing_amount !~ JUST_DOLLARS_AND_CENTS
      "ERROR: Target dollar amount should include both dollars and cents."
    else
      begin
        db.back_project(given_name, 0, credit_card_number, backing_amount)
        "Success"
      rescue MiniKickstarterDB::ProjectAlreadyBackedError
        return "ERROR: The credit card number has already been entered."
      end
    end
  end

  def invoke_list(db, command_params)
    db.list_projects
  end

  def valid_luhn_10_sequence?(digits)
    odd_digits = []
    even_digits = []

    # TODO: Investigate more concise options.
    digits.reverse.each_index do |index|
      if (index+1) % 2 == 0
        even_digits << digits[index]
      else
        odd_digits << digits[index]
      end
    end

    total = odd_digits.reduce(&:+)
    even_digits.each { |ed| total += (2*ed).to_s.split(//).map(&:to_i).reduce(&:+) }

    (total % 10) == 0
  end
end
