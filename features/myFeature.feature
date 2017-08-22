Feature: only a test feature

  @ru
  Scenario: only a first test without async
    When go to google main page
    Then all necessary elements are visible without async

  @ru
  Scenario: only a first test with async
    When go to google main page
    Then all necessary elements are visible with async

  @run
  Scenario: test scenario
    When a test is running
