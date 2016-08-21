Feature: "project" command

  Scenario Outline: Projects should be alphanumeric
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | project | message                                                                    |
      | example |                                                                    Success |
      | EXAMPLE |                                                                    Success |
      | 3xampl3 |                                                                    Success |
      | ex@mpl3 | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed. |
      | $$$$$$$ | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed. |
      |  thí_dụ |                                                                    Success |
      |     ___ | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed. |
      |     --- | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed. |

  Scenario Outline: Projects can include underscores or dashes
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should <response> the command input

    Examples:
      | project | response |
      | ex_mple |   accept |
      | _xample |   accept |
      | exampl_ |   accept |
      | ex-mple |   accept |
      | -xample |   accept |
      | exampl- |   accept |
      | e_amp-e |   accept |

  Scenario Outline: Projects must be between 4 and 20 characters long
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | project               | message                                                                                  |
      | exa                   | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters. |
      | exam                  |                                                                                  Success |
      | 20ampleexampleexampl  |                                                                                  Success |
      | 21ampleexampleexample | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters. |
      | thí                   | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters. |
      | thí_dụthí_dụthí_dụthí | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters. |

  # TODO: Clarify whether this MUST accept BOTH dollars and cents or whether just dollars would suffice.
  Scenario: Target dollar amounts should accept both dollars and cents
    Given a project with a valid name
    And a target dollar amount of "1000000.00"
    When the "project" command is invoked
    Then Mini Kickstarter should accept the command input

  Scenario: Target dollar amounts cannot have the $ currency symbol
    Given a project with a valid name
    And a target dollar amount of "$1000000.00"
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "ERROR: Target dollar amount should not use the $ currency symbol."

  Scenario Outline: Target dollar amounts should not accept amounts with missing or extra digits
    Given a project with a valid name
    And a target dollar amount of "<amount>"
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount |                                                            message |
      |  01.07 | ERROR: Target dollar amount should include both dollars and cents. |
      |    0.7 | ERROR: Target dollar amount should include both dollars and cents. |
      |     1. | ERROR: Target dollar amount should include both dollars and cents. |
      |     .7 | ERROR: Target dollar amount should include both dollars and cents. |
