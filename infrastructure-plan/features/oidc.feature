Feature: Open ID Connect Github Provider

    Scenario Outline: Authenticated Repositories
        Given I have aws_iam_openid_connect_provider defined
        When its tags includes an entry where Team is <team>
        Then it should have Statement 
        Then it should have Condition 
        Then it should have StringLike 
        Then its token.actions.githubusercontent.com:sub contains <repository_conditions>

        Examples:
        | team                      | repository_conditions                                     |
        | Data Engineering          | repo:mygainwell/acuity-data-engineering:ref:refs/heads/*  |
        | BI Engineers              | repo:mygainwell/acuity-tableau:ref:refs/heads/*           | # Team Analysts?
        | Infrastructure            | repo:mygainwell/acuity-terraform-modules:ref:refs/heads/* |
        | Infrastructure            | repo:mygainwell/acuity-aws-stacks:ref:refs/heads/*        |
        | Infrastructure            | repo:mygainwell/acuity-platform-live:ref:refs/heads/*     |
        | Security                  | repo:mygainwell/acuity-management-live:ref:refs/heads/*   |
        | gainwell-360-ui           | repo:mygainwell/gainwell-360-ui:ref:refs/heads/*          | # Team name ?
        | gainwell-360-api          | repo:mygainwell/gainwell-360-api:ref:refs/heads/*         | # Team name ?
        | Security                  | repo:mygainwell/acuity-auth:ref:refs/heads/*              | # Optional ?


    Scenario Outline: Permitted Full Access 
        Given I have aws_iam_openid_connect_provider 
        Then the 
        Examples: 
        | repository        | full_access   |  
        | gainwell-360-ui   | ecs           |
        | gainwell-360-ui   | ecr           |
        | acuity-tableau    | ecs           |
        | acuity-tableau    | ecr           |
        | acuity-tableau    | ebs           |
        | acuity-tableau    | s3            |
        | acuity-tableau    | efs           |
        | gainwell-360-api  | ecs           |
        | gainwell-360-api  | ecr           |
        | gainwell-360-api  | ebs           |
        | gainwell-360-api  | s3            |
        | gainwell-360-api  | efs           |
        | gainwell-360-api  | rds           |
