Feature: "backer" command

  Scenario: Display the projects and backing amounts of a backer
    Given a project called "Awesome_Sauce" has been created with a target dollar amount of $500
    And a project has been backed by "John" for $50.00 with card number 79927398713
    When the "backer" command is invoked for backer "John"
    Then Mini Kickstarter should respond with:
    """
    -- Backed Awesome_Sauce for $50
    """
