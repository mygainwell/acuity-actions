Feature: Before PHI can be loaded Security must sign off on the environment
  In order to comply with security
  As engineers
  We will remediate vulnerabilities and enforce NIST 800-53 R4 standards
  
  Scenario: Apply MFA to IAM Users
    Given I have aws_iam_user defined
    Then it has enforce_mfa
    And its value True

  Scenario: Enforce TLS 1.2 on all S3 Buckets
    Given a aws_s3_bucket exists
    Then aws_s3_bucket_policy must have a Deny Effect on EnforceTLS Sid when aws:SecureTransport Condition equals false
    Then it has Statement
    Then it has Condition
    Then it has StringEquals
    Then it has "S3:TlsVersion"
    And its value is "1.2"
   
  # See landing bucket specs 
  Scenario: Create S3 logging bucket
    Given an aws_s3_bucket exits
    When aws_access_logs is enabled
    Then a logging aws_s3_bucket must exist
     
  # See landing bucket specs
  Scenario: Ensure S3 bucket-access logging is on
    Given a aws_s3_bucket exists
    Then aws_s3_bucket_policy must have s3_access_log set to aws_s3_bucket created for logs    
  
  Scenario: Verify MFA to all IAM Users
    Given an aws_iam_user exists
    Then it has aws-enforce-mfa 
    And its value is "true"
   
  Scenario: Ensure IAM password policy meets standards
    Given that aws_iam_account_password_policy exists
    Then minimum_password_length        = 16
      require_lowercase_characters   = true
      require_numbers                = true
      require_uppercase_characters   = true
      require_symbols                = true
      allow_users_to_change_password = true
      password_reuse_prevention      = 24
      max_password_age               = 60
