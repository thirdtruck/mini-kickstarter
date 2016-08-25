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
      | name    | message                                                                      |
      | example |                                 example backed project Awesome_Sauce for $50 |
      | EXAMPLE |                                 EXAMPLE backed project Awesome_Sauce for $50 |
      | 3xampl3 |                                 3xampl3 backed project Awesome_Sauce for $50 |
      | ex@mpl3 | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed |
      | $$$$$$$ | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed |
      |  thí_dụ |                                  thí_dụ backed project Awesome_Sauce for $50 |
      |     ___ | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed |
      |     --- | ERROR: Given names should be alphanumeric. Underscores or dashes are allowed |

  Scenario Outline: Given names can include underscores or dashes
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | name    | message                                      |
      | ex_mple | ex_mple backed project Awesome_Sauce for $50 |
      | _xample | _xample backed project Awesome_Sauce for $50 |
      | exampl_ | exampl_ backed project Awesome_Sauce for $50 |
      | ex-mple | ex-mple backed project Awesome_Sauce for $50 |
      | -xample | -xample backed project Awesome_Sauce for $50 |
      | exampl- | exampl- backed project Awesome_Sauce for $50 |
      | e_amp-e | e_amp-e backed project Awesome_Sauce for $50 |

  Scenario Outline: Projects must be between 4 and 20 characters long
    Given a given name of "<name>"
    And a project with a valid name
    And a valid credit card number
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # TODO: Perform more thorough checks of Unicode strings.
    Examples:
      | name                  | message                                                                                    |
      | exa                   | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters |
      | exam                  |                                                  exam backed project Awesome_Sauce for $50 |
      | 20ampleexampleexampl  |                                  20ampleexampleexampl backed project Awesome_Sauce for $50 |
      | 21ampleexampleexample | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters |
      | thí                   | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters |
      | thí_dụthí_dụthí_dụthí | ERROR: Given names should be no shorter than 4 characters but no longer than 20 characters |

  # TODO: Clarify whether this MUST accept BOTH dollars and cents or whether just dollars would suffice.
  Scenario Outline: Backing amounts should accept both dollars and cents
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "<amount>"
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount   | message                                        |
      |        1 |       Jane backed project Awesome_Sauce for $1 |
      |     1.00 |       Jane backed project Awesome_Sauce for $1 |
      |    19.95 |   Jane backed project Awesome_Sauce for $19.95 |
      |      500 |     Jane backed project Awesome_Sauce for $500 |
      |  1000000 | Jane backed project Awesome_Sauce for $1000000 |

  Scenario Outline: Backing amounts cannot have the $ currency symbol
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "<amount>"
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "ERROR: Target dollar amount should not use the $ currency symbol"

    Examples:
      | amount   |
      | $1000000 |
      | $1000.00 |

  Scenario Outline: Backing amounts should not accept amounts with missing or extra digits
    Given a valid given name
    And a project with a valid name
    And a valid credit card number
    And a backing amount of "<amount>"
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | amount | message                                                           |
      |  01.07 | ERROR: Target dollar amount should include both dollars and cents |
      |    0.7 | ERROR: Target dollar amount should include both dollars and cents |
      |     1. | ERROR: Target dollar amount should include both dollars and cents |
      |     .7 | ERROR: Target dollar amount should include both dollars and cents |

  Scenario Outline: Credit card numbers may be up to 19 characters long
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   | message                                   |
      |  1000000000000000009 | Jane backed project Awesome_Sauce for $50 |
      | 10000000000000000009 |               ERROR: This card is invalid | 

  Scenario Outline: Credit card numbers will always be numeric
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    # Getting more specific here to make sure we're rejecting the number for the right reason.
    Examples:
      | credit_card_number   | message                                   |
      |          79927398713 | Jane backed project Awesome_Sauce for $50 |
      |        799-2739-8713 |               ERROR: This card is invalid |

  Scenario Outline: Credit card numbers should be validated using Luhn-10
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   | message                                   |
      |          79927398713 | Jane backed project Awesome_Sauce for $50 |
      |          79927398710 |               ERROR: This card is invalid |
      |          79927398711 |               ERROR: This card is invalid |
      |          79927398712 |               ERROR: This card is invalid |
      |          79927398714 |               ERROR: This card is invalid |
      |          79927398715 |               ERROR: This card is invalid |
      |          79927398716 |               ERROR: This card is invalid |
      |          79927398717 |               ERROR: This card is invalid |
      |          79927398718 |               ERROR: This card is invalid |
      |          79927398719 |               ERROR: This card is invalid |

  # While implicitly covered in other scenarios, the project specs list this requirement explicitly.
  Scenario Outline: Credit card numbers that fail Luhn-10 will display an error
    Given a valid given name
    And a project with a valid name
    And a credit card number of "<credit_card_number>"
    And a valid backing amount
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "<message>"

    Examples:
      | credit_card_number   | message                     |
      |          79927398710 | ERROR: This card is invalid |
      |        799-2739-8713 | ERROR: This card is invalid |
      | 10000000000000000009 | ERROR: This card is invalid |

  Scenario: Credit card numbers that have already been added will display an error
    Given a valid given name
    And a project with a valid name
    And a credit card number of "79927398713"
    And a valid backing amount
    And the credit card number "79927398713" has already been entered
    When the "back" command is invoked
    Then Mini Kickstarter should respond with "ERROR: That card has already been added by another user!"
