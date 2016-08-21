Feature: "back" command

  Background:
    Given a project has been created

  Scenario Outline: Given names should be alphanumeric
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | name    | message                                                                       |
      | example |                                                                       Success |
      | EXAMPLE |                                                                       Success |
      | 3xampl3 |                                                                       Success |
      | ex@mpl3 | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed. |
      | $$$$$$$ | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed. |
      |  thí_dụ |                                                                       Success |
      |     ___ | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed. |
      |     --- | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed. |

  Scenario Outline: Given names can include underscores or dashes
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | name    | message   |
      | ex_mple |   Success |
      | _xample |   Success |
      | exampl_ |   Success |
      | ex-mple |   Success |
      | -xample |   Success |
      | exampl- |   Success |
      | e_amp-e |   Success |

  Scenario Outline: Projects must be between 4 and 20 characters long
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | name                  | message                                                                                     |
      | exa                   | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters. |
      | exam                  |                                                                                     Success |
      | 20ampleexampleexampl  |                                                                                     Success |
      | 21ampleexampleexample | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters. |
      | thí                   | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters. |
      | thí_dụthí_dụthí_dụthí | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters. |

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
    Then Mini Kickstarter should respond with "ERROR: Target dollar amount should not use the $ currency symbol."

  Scenario Outline: Backing amounts should not accept amounts with missing or extra digits
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "<amount>"
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount | message                                                            |
      |  01.07 | ERROR: Target dollar amount should include both dollars and cents. |
      |    0.7 | ERROR: Target dollar amount should include both dollars and cents. |
      |     1. | ERROR: Target dollar amount should include both dollars and cents. |
      |     .7 | ERROR: Target dollar amount should include both dollars and cents. |

  Scenario Outline: Credit card numbers may be up to 19 characters long
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   | message                                                          |
      |  1000000000000000009 |                                                          Success |
      | 10000000000000000009 | ERROR: Credit card numbers should be no more than 19 characters. |

  Scenario Outline: Credit card numbers will always be numeric
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # Getting more specific here to make sure we're rejecting the number for the right reason.
    Examples:
      | credit_card_number   | message                                                  |
      |          79927398713 |                                                  Success |
      |        799-2739-8713 |   ERROR: Credit card numbers should contain only digits. |

  Scenario Outline: Credit card numbers should be validated using Luhn-10
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   | message                            |
      |          79927398713 |                            Success |
      |          79927398710 | ERROR: Invalid credit card number. |
      |          79927398711 | ERROR: Invalid credit card number. |
      |          79927398712 | ERROR: Invalid credit card number. |
      |          79927398714 | ERROR: Invalid credit card number. |
      |          79927398715 | ERROR: Invalid credit card number. |
      |          79927398716 | ERROR: Invalid credit card number. |
      |          79927398717 | ERROR: Invalid credit card number. |
      |          79927398718 | ERROR: Invalid credit card number. |
      |          79927398719 | ERROR: Invalid credit card number. |

  # While implicitly covered in other scenarios, the project specs list this requirement explicitly.
  Scenario Outline: Credit card numbers that fail Luhn-10 will display an error
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   |                                                          message |
      |          79927398710 | ERROR: Invalid credit card number.                               |
      |        799-2739-8713 | ERROR: Credit card numbers should contain only digits.           |
      | 10000000000000000009 | ERROR: Credit card numbers should be no more than 19 characters. |

  Scenario: Credit card numbers that have already been added will display an error
    Given a valid given name
    And a project with a valid name
    And a credit card number of "79927398713"
    And a valid backing amount
    And the credit card number "79927398713" has already been entered
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "ERROR: The credit card number has already been entered."
