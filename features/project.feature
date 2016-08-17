Feature: "project" command

  Scenario Outline: Projects should be alphanumeric
    Given a project called "<project>"
    And a valid target dollar amount
    When the "project" command is invoked
    Then Mini Kickstarter should <response> the command input

    Examples:
      | project | response |
      | example |   accept |
      | EXAMPLE |   accept |
      | 3xampl3 |   accept |
      | ex@mpl3 |   reject |
      | $$$$$$$ |   reject |
      |  thí dụ |   accept |

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
    Then Mini Kickstarter should <response> the command input

    Examples:
      | project               | response |
      | exa                   |   reject |
      | exam                  |   accept |
      | 20ampleexampleexampl  |   accept |
      | 21ampleexampleexample |   reject |

  Scenario: Target dollar amounts should accept both dollars and cents
    Given a project with a valid name
    And a target dollar amount of "1000000.00"
    When the "project" command is invoked
    Then Mini Kickstarter should accept the command input

  Scenario: Target dollar amounts cannot have the $ currency symbol
    Given a project with a valid name
    And a target dollar amount of "$1000000.00"
    When the "project" command is invoked
    Then Mini Kickstarter should reject the command input
