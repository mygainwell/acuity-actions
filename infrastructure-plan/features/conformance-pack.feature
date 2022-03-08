"""
 Feature: Conformance Pack
  In order to comply with security
  As engineers
  We'll deploy AWS Conformance Pack

  Scenario Outline: 
    Given Conformance Pack Operational Best Practices for FedRAMP(Moderate) is deployed
    When <iam-user> is created
    And the <password> is under 14 charecters
    Then <aws-config-rule> event is triggered    

    Examples:
      | iam-user | password | aws-config-rule     |
      | insecure | bad      | IAM_PASSWORD_POLICY | 
      
      https://docs.aws.amazon.com/config/latest/developerguide/iam-password-policy.html
"""