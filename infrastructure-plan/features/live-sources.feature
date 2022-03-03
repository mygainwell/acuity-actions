Feature: Live Infrastructure Sources

    Scenario Outline: Ensure our live infrastructure comes from a trusted source.
        Given I have a resource defined
        Then its name must match the "^(stacks|modules)" regex
        When its name is <name>
        Then it must contain source
        And its value must match the <pattern> regex

        Examples:
        | name    | pattern                                   |
        | stacks  | mygainwell\/acuity-aws-stacks\.git        |
        | modules | mygainwell\/acuity-terraform-modules\.git |
        | modules | gruntwork-io\/.*\.git                     |
