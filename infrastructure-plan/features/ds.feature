Feature: Directory Service Standards AWS

    Scenario Outline: Directory Service Properties
        Given I have aws_directory_service_directory defined
        Then it must have <property>
        And its value must be <pattern>

        Examples:
        | property | pattern     |
        | edition  | Enterprise  |
        | type     | MicrosoftAD |

    Scenario: Directory Service Subnets
        Given I have aws_directory_service_directory defined
        When it has vpc_settings
        Then it must contain subnet_ids
        And its value must not be null
