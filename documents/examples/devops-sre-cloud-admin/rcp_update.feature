Feature: RCP Update Flow with Failover and Escalation
  Scenario: Initial update job fails and AI attempts remediation
    Given the RCP update script is triggered
    When the job fails on 27 endpoints
    Then the AI bot should retry using token regeneration

  Scenario: AI bot fails due to IAM policy
    Given the AI bot lacks permission to regenerate tokens
    Then a support engineer should be notified
    And IAM policy should be corrected

  Scenario: Post-incident retry and report generation
    Given the policy is fixed
    When the AI bot retries the update
    Then it should succeed
    And a post-incident report should be generated
    And a validator should confirm IAM automation is in place