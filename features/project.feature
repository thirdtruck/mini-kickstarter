Feature: "project" command

  Scenario Outline: Projects should be alphanumeric
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | project | message                                                                   |
      | example |                                 Added example project with target of $500 |
      | EXAMPLE |                                 Added EXAMPLE project with target of $500 |
      | 3xampl3 |                                 Added 3xampl3 project with target of $500 |
      | ex@mpl3 | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed |
      | $$$$$$$ | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed |
      |  thí_dụ |                                  Added thí_dụ project with target of $500 |
      |     ___ | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed |
      |     --- | ERROR: Projects should be alphanumeric. Underscores or dashes are allowed |

  # TODO: Get more exacting expectations for underscores and dashes.
  Scenario Outline: Projects can include underscores or dashes
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | project | message                                   |
      | ex_mple | Added ex_mple project with target of $500 |
      | _xample | Added _xample project with target of $500 |
      | exampl_ | Added exampl_ project with target of $500 |
      | ex-mple | Added ex-mple project with target of $500 |
      | -xample | Added -xample project with target of $500 |
      | exampl- | Added exampl- project with target of $500 |
      | e_amp-e | Added e_amp-e project with target of $500 |

  Scenario Outline: Projects must be between 4 and 20 characters long
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | project               | message                                                                                 |
      | exa                   | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters |
      | exam                  |                                                  Added exam project with target of $500 |
      | 20ampleexampleexampl  |                                  Added 20ampleexampleexampl project with target of $500 |
      | 21ampleexampleexample | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters |
      | thí                   | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters |
      | thí_dụthí_dụthí_dụthí | ERROR: Projects should be no shorter than 4 characters but no longer than 20 characters |

  # TODO: Clarify whether this MUST accept BOTH dollars and cents or whether just dollars would suffice.
  Scenario Outline: Target dollar amounts should accept both dollars and cents
    Given a project with a valid name
    And a target dollar amount of "<amount>"
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount   | message                                             |
      |        1 |       Added Awesome_Sauce project with target of $1 |
      |     1.00 |       Added Awesome_Sauce project with target of $1 |
      |    19.95 |   Added Awesome_Sauce project with target of $19.95 |
      |      500 |     Added Awesome_Sauce project with target of $500 |
      |  1000000 | Added Awesome_Sauce project with target of $1000000 |

  Scenario: Target dollar amounts cannot have the $ currency symbol
    Given a project with a valid name
    And a target dollar amount of "$1000000.00"
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "ERROR: Target dollar amount should not use the $ currency symbol"

  Scenario Outline: Target dollar amounts should not accept amounts with missing or extra digits
    Given a project with a valid name
    And a target dollar amount of "<amount>"
    When the "project" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount |                                                           message |
      |  01.07 | ERROR: Target dollar amount should include both dollars and cents |
      |    0.7 | ERROR: Target dollar amount should include both dollars and cents |
      |     1. | ERROR: Target dollar amount should include both dollars and cents |
      |     .7 | ERROR: Target dollar amount should include both dollars and cents |
