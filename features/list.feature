Feature: "list" command

  Scenario: Display a project's backers and backed amounts
    Given a project has been created
    And a project has been backed by "John" for $50.00 with card number 79927398713
    And a project has been backed by "Jane" for $50.00 with card number 79927398721
    When the "list" command is invoked
    Then Mini Kickstarter should respond with:
    """
    -- John backed for $50
    -- Jane backed for $50
    Awesome_Sauce needs $400 more dollars to be successful
    """

  Scenario: Report that a project is successful when it is fully funded
    Given a project called "Awesome_Sauce" has been created with a target dollar amount of $500.00
    And a project has been backed by "John" for $50.00 with card number 79927398713
    And a project has been backed by "Jane" for $50.00 with card number 79927398721
    And a project has been backed by "Mary" for $400.00 with card number 79927398739
    When the "list" command is invoked
    Then Mini Kickstarter should respond with:
    """
    -- John backed for $50
    -- Jane backed for $50
    -- Mary backed for $400
    Awesome_Sauce is successful!
    """
