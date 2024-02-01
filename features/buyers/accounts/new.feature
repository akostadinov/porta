@javascript
Feature: Audience > Accounts > New

  Background:
    Given a provider is logged in

  Scenario: Navigation
    Given they go to the provider dashboard
    When they follow "0 Accounts" within the audience dashboard widget
    And follow "Add your first account"
    Then the current page is the new buyer account page

  Scenario: Creating an account
    Given they go to the new buyer account page
    And the form is submitted with:
      | Username                | alice              |
      | Email                   | alice@example.com  |
      | Organization/Group Name | Alice's Web Widget |
    Then the current page is the buyer account page for "Alice's Web Widget"

  Scenario: Creating an account without legal terms
    Given the provider has no legal terms
    When they go to the new buyer account page
    And the form is submitted with:
      | Organization/Group Name | Alice's Web Widget |
      | Username                | alice              |
      | Email                   | alice@example.com  |
    Then the current page is the buyer account page for "Alice's Web Widget"
    And account "Alice's Web Widget" should be approved
    And user "alice" should be active
    But "alice@web-widgets.com" should receive no emails

  Scenario: Required fields and validation
    Given they go to the new buyer account page
    When press "Create"
    Then field "Username" has inline error "is too short"
    And field "Email" has inline error "should look like an email address"
    And field "Organization/Group Name" has inline error "can't be blank"
    But field "Password" has no inline error
