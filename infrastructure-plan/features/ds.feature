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
