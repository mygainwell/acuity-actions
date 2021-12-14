Feature: Directory Service Standards AWS

    Scenario Outline: Directory Service Properties
        Given I have aws_directory_service_directory defined
        Then it must have <property>
        Then it must be <value>

        Examples:
        | property | value       |
        | edition  | Enterprise  |
        | type     | MicrosoftAD |

    Scenario: Directory Service Subnets
        Given I have aws_directory_service_directory defined
        When it contains vpc_settings
        Then it must contain subnet_ids
        And its value must not be null
