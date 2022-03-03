@1640
Feature: Single Sign On
  In order to comply with security
  As engineers
  We'll deploy Okta

  Scenario Outline: Cross Service Authentication
    Given <username> authenticated to <first_service>
    When <username> navigates to <second_service>
    Then <username> redirected to <page>

    Examples:
      | username   | first_service                    | second_service                   | page                                   |
      | gw360      | analytics.gwtacuity.com          | acuity-demo.cloud.databricks.com | login                                  |
      | databricks | acuity-demo.cloud.databricks.com | analytics.gwtacuity.com          | login                                  |
      | gw360      | analytics.gwtacuity.com          | tableau.gwtacuity.com            | login                                  |
      | tableau    | tableau.gwtacuity.com            | analytics.gwtacuity.com          | login                                  |
      | privleged  | analytics.gwtacuity.com          | tableau.gwtacuity.com            | tableau.gwtacuity.com/#/home           |
      | privleged  | analytics.gwtacuity.com          | acuity-demo.cloud.databricks.com | ?o=4419192288801181#                   |
      | privleged  | acuity-demo.cloud.databricks.com | analytics.gwtacuity.com          | analytics.gwtacuity.com/#/my-portfolio |
      | neither    | analytics.gwtacuity.com          | acuity-demo.cloud.databricks.com | login                                  |
      | neither    | acuity-demo.cloud.databricks.com | analytics.gwtacuity.com          | login                                  |

  Scenario Outline: Authentication Timeout
    Given <username> authenticated to <first_service>
    When <username> navigates to <second_service> after <minutes> 
    Then <username> redirected to <page>

    Examples:
      | username   | first_service                    | second_service                   | time     | page                                   |
      | privleged  | analytics.gwtacuity.com          | acuity-demo.cloud.databricks.com | 00:05:00 | ?o=4419192288801181#                   |
      | privleged  | acuity-demo.cloud.databricks.com | analytics.gwtacuity.com          | 00:05:00 | analytics.gwtacuity.com/#/my-portfolio |
      | privleged  | analytics.gwtacuity.com          | acuity-demo.cloud.databricks.com | 00:00:05 | login                                  |
      | privleged  | acuity-demo.cloud.databricks.com | analytics.gwtacuity.com          | 00:00:05 | login                                  |
