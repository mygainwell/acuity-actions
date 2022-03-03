AB#6205
Feature: Tag Naming Standards AWS

    Scenario Outline: Ensure that specific tags are defined
        Given I have resource that supports tags defined
        When it has tags
        Then it must contain tags
        Then it must contain "<tags>"
        And its value must match the "<value>" regex

        Examples:
        | tags                 | value                                                       |
        | Company              | .+                                                          |
        | Environment          | ^(Ephemeral\|Production\|Management\|Development\|Staging)$ |
        | Project              | .+                                                          |
        | Email                | .+                                                          |
        | ManagedBy            | ^(Terraform)$                                               |
        
    Scenario Outline: Ensure that specific tags are defined for EC2
        Given I have aws_instance that supports tags defined
        And aws_instance type is EC2 
        When it has tags
        Then it must contain tags
        Then it must contain "<tags>"
        And its value must match the "<value>" regex
        Examples:
        | tags               | value                          |
        | qualysAgentInstall | ^(TRUE)$                       |
        | nessusAgentInstall | ^(TRUE)$                       |
