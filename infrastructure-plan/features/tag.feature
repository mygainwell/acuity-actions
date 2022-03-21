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
        | Team                 | .+                                                          |    
        | Email                | .+                                                          |
        | ManagedBy            | ^(Terraform)$                                               |
