Feature: only a test feature

  @run
  Scenario: only a first test without async
    When go to google main page
    Then all necessary elements are visible without async

  @run
  Scenario: only a first test with async
    When go to google main page
    Then all necessary elements are visible with async
