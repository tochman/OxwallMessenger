Feature: 
  As a user

Scenario: 
    I launch the app
Given I launch the app using iOS 6.1 and the iphone simulator

Then I should see a navigation bar titled "Oxwall Messenger"


Feature: Login to the app
  Scenario: Successful login
    Given I launch the app
    When I enter a valid userid and password
    When I tap on the login button
    Then I should be on the view marked "Profile"