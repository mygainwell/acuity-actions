Feature: Infrastructure Sources

    Scenario Outline: Ensure our infrastructure comes from a trusted source.
        Given I have a resource defined
        Then its name must match the "^(stack|module)" regex
        When its name is <name>
        Then it must contain source
        And its value must match the <pattern> regex

        Examples:
        | name   | pattern                                   |
        | stack  | mygainwell\/acuity-aws-stacks\.git        |
        | module | mygainwell\/acuity-terraform-modules\.git |
        | module | gruntwork-io\/.*\.git                     |
