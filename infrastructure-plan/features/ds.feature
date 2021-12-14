Feature: Directory Service Standards AWS

    Scenario: 
        Given I have aws_directory_service_directory
        Then it must contain edition
        And its value must be "Enterprise"
        Then is must contain type
        And its value must be "MicrosoftAD"

    Scenario Outline: Directory Service Subnets
        Given I have aws_directory_service_directory defined
        When it contains vpc_settings
        Then it must contain subnet_ids
        And its value must not be null

    Scenario Outline: Directory Services is listening on LDAPS and not LDAP ports
        Given I have aws_directory_service_directory defined
        When it contains vpc_settings
        When a Telnet command is executed
        Then its value should be <response>

        Examples:
        | domain        | port  | response  |
        | acuity.local  | 389   | failure   |
        | acuity.local  | 636   | pass      |