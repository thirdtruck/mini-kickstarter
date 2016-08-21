Feature: "list" command

  Scenario: Display a project's backers and backed amounts
    Given a project has been backed
    When the "list" command is invoked
    Then Mini Kickstarter should respond with:
    """
    -- John backed for $50
    -- Jane backed for $50
    Awesome_Sauce needs $400 more dollars to be successful
    """
