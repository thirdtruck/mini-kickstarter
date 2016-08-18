Feature: "back" command

  Scenario Outline: Given names should be alphanumeric
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should <response> the command input

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | name    | response |
      | example |   accept |
      | EXAMPLE |   accept |
      | 3xampl3 |   accept |
      | ex@mpl3 |   reject |
      | $$$$$$$ |   reject |
      |  thí_dụ |   accept |
      |     ___ |   reject |
      |     --- |   reject |

  Scenario Outline: Given names can include underscores or dashes
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should <response> the command input

    Examples:
      | name    | response |
      | ex_mple |   accept |
      | _xample |   accept |
      | exampl_ |   accept |
      | ex-mple |   accept |
      | -xample |   accept |
      | exampl- |   accept |
      | e_amp-e |   accept |

  Scenario Outline: Projects must be between 4 and 20 characters long
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should <response> the command input

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | name                  | response |
      | exa                   |   reject |
      | exam                  |   accept |
      | 20ampleexampleexampl  |   accept |
      | 21ampleexampleexample |   reject |
      | thí                   |   reject |
      | thí_dụthí_dụthí_dụthí |   reject |

  # TODO: Clarify whether this MUST accept BOTH dollars and cents or whether just dollars would suffice.
  Scenario: Backing amounts should accept both dollars and cents
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    And a backing amount of "1000000.00"
    When the "back" command is invoked
    Then Mini Kickstarter should accept the command input

  Scenario: Backing amounts cannot have the $ currency symbol
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "$1000000.00"
    When the "back" command is invoked
    Then Mini Kickstarter should reject the command input

  Scenario Outline: Backing amounts should not accept amounts with missing or extra digits
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "<amount>"
    When the "back" command is invoked
    Then Mini Kickstarter should <response> the command input

    Examples:
      | amount | response |
      |  01.07 |   reject |
      |    0.7 |   reject |
      |     1. |   reject |
      |     .7 |   reject |

  # Testing credit card numbers with only digits (e.g. no dashes) for simplicity's sake.
  Scenario Outline: Credit card numbers may be up to 19 characters long
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should <response> the command input

    # TODO: Use a number that passes Luhn-10 below
    Examples:
      | credit_card_number   | response |
      |  1234567890123456789 |   accept |
      | 12345678901234567890 |   reject |