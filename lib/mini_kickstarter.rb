class MiniKickstarter
  ALPHANUMERIC_WITH_UNDERSCORES_DASHES = /\A[[:alnum:]_-]*[[:alnum:]]+[[:alnum:]_-]*\z/

  def invoke(command_name, command_params)
    project_name = command_params[:project_name]

    if project_name !~ ALPHANUMERIC_WITH_UNDERSCORES_DASHES 
      "ERROR: Projects should be alphanumeric. Undersores or dashes are allowed."
    # We could also capture the length requirements in the regular expression, but informative
    # error messages take priority.
    # TODO: Compile all errors before reporting instead of reporting only the first match. Better UX.
    # #mb_chars
    elsif project_name.length < 4 || project_name.length > 20
      "ERROR: Projects should be no shorter than 3 characters but no longer than 20 characters."
    else
      "Success"
    end
  end
end
