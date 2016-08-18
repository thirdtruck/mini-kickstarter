class MiniKickstarter
  # TODO: Move checks into the option parser. Take only pre-vetted input.
  ALPHANUMERIC_WITH_UNDERSCORES_DASHES = /\A[[:alnum:]_-]*[[:alnum:]]+[[:alnum:]_-]*\z/
  JUST_DOLLARS_AND_CENTS = /\A([1-9][0-9]*|[0-9])\.[0-9]{2}\z/

  def invoke(command_name, command_params)
    project_name = command_params[:project_name]
    target_dollar_amount = command_params[:target_dollar_amount]

    # We could also capture the length requirements in the regular expression, but informative
    # error messages take priority.
    #
    # Separating the amount requirements for a better error UX, too.
    #
    # TODO: Compile all errors before reporting instead of reporting only the first match. Better UX.
    # TODO: Do we need to use #mb_chars here? Doesn't seem to be the case.
    if project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES 
      "ERROR: Projects should be alphanumeric. Undersores or dashes are allowed."
    elsif project_name.length < 4 || project_name.length > 20
      "ERROR: Projects should be no shorter than 3 characters but no longer than 20 characters."
    elsif target_dollar_amount =~ /\$/
      "ERROR: Target dollar amount should not use the $ currency symbol."
    elsif target_dollar_amount !~ JUST_DOLLARS_AND_CENTS
      "ERROR: Target dollar amount should include both dollars and cents."
    else
      "Success"
    end
  end
end
