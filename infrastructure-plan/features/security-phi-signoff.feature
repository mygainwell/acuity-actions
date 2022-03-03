@2542
Feature: Before PHI can be loaded Security must sign off on the environment
  In order to comply with security
  As engineers
  We will remediate vulnerabilities and enforce NIST 800-53 R4 standards
  
  Scenario: Apply MFA to IAM Users
    Given I have aws_iam_user defined
    Then that aws_iam_user must have enforce_mfa

  Scenario: Enforce TLS on all S3 Buckets
    Given a aws_s3_bucket exists
    Then aws_s3_bucket_policy must have a Deny Effect on EnforceTLS Sid when aws:SecureTransport Condition equals false
    
  Scenario: Create S3 logging bucket
    Given an aws_s3_bucket exits
    When aws_access_logs is enabled
    Then a logging aws_s3_bucket must exist
     
  Scenario: Ensure S3 bucket-access logging is on
    Given a aws_s3_bucket exists
    Then aws_s3_bucket_policy must have s3_access_log set to aws_s3_bucket created for logs    
  
  Scenario: Verify MFA to all IAM Users
    Given an aws_iam_user exists
    Then the aws_iam_user needs to have aws-enforce-mfa set to "true"
    
  Scenario: Rescope "acuity-admin" IAM Policy to be more restrictive based on cloud trail utilzation history
    Given that aws_iam_policy for acuity-admin is available
    Then new aws_iam_policy acuity-cicd-policy must be created with more-limited permissions
    Then acuity-cicd-policy must be applied to acuity-cicd-admin-poc aws_iam_role
    Then acuity-cicd-policy must have acuity-admin removed
    
  Scenario: Remove Security Groups from Dev Environment
    Given that aws_security_group exists but is not attached to an aws_instance
    Then the aws_security_group must be deleted.
  
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
  
  Scenario: Ensure a log metric filter and alarm exist for S3 bucket policy changes
    Given aws_s3_bucket exists
    When the aws_s3_bucket_policy is changed
    Then aws_sns_topic_subscription should be enabled to send alerts
  
  Scenario: Require S3 bucket-access logging is enabled for *NEW* buckets
    Given a new aws_s3_bucket is created
    Then aws_access_logs should be enabled
    
    
['LogFormat'] == "${account-id} ${action} ${az-id} ${bytes} ${dstaddr} ${dstport} ${end} ${flow-direction} ${instance-id} ${interface-id} ${log-status} ${packets} ${pkt-dst-aws-service} ${pkt-dstaddr} ${pkt-src-aws-service} ${pkt-srcaddr} ${protocol} ${region} ${srcaddr} ${srcport} ${start} ${sublocation-id} ${sublocation-type} ${subnet-id} ${tcp-flags} ${traffic-path} ${type} ${version} ${vpc-id}":
from Veera Matukumalli to everyone:    11:59 AM
log_format = "$${version} $${vpc-id} $${subnet-id} $${instance-id} $${interface-id} $${account-id} $${type} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${pkt-srcaddr} $${pkt-dstaddr} $${protocol} $${bytes} $${packets} $${start} $${end} $${action} $${tcp-flags} $${log-status}"
