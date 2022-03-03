@1559
Feature: Active Directory should be implemented to provide authenitcation and authorization services
  In order to comply with security
  As engineers
  We'll deploy AWS Directory Services
  
  Scenario: Create Credential Manager to store AD Secrets
    Given 
    When crednetials are provided for Active Directory
    Then a credential manager should be deployed to store admin credentials
    
  Scenario Outline: Create Deployment for manage AD Directory Services
    Given <name>
    And <password>
    And <edition>
    And <type> 
    Then deploy managed AD in <vpc> with resources in <subnet1> and <subnet2> within <subscription>
    
    Examples:
      | name          | password | edition  | type        | vpc | subnet1 | subnet2 | subscription |
      | acuity.local  | <Secret> | Standard | MicrosoftAD |     |         |         | management   |

  Scenario Outline: Directory Services is listening on LDAPS and not LDAP ports
    Given Directory Services are installed
    And <domain>
    And <port>
    When a Telnet command is executed
    Then its value shold be <response>    

    Examples:
      | domain        | port  | response  |
      | acuity.local  | 389   | failure   |
      | acuity.local  | 636   | pass      |
  
  Scenario Outline: Directory Services can authenticate as an application end user
    Given <username>
    And <password>
    When a authentication request is made
    Then the output should be <response>
    And the user should have assigned to <priveldge>

    Examples:
      | username      | password     | response  | priveldge    |
      | Administrator | aws valut id | failure   | Administror  |
      | InvalidUser   | P@$$w0rd     | pass      | N/A          |
      | ValidUser     | P@ssword     | pass      | User         |

    Scenario Outline: Directory Services and IAM relationship exists
    Given
    When a ephemeral is applied
    Then RBAC Role mapped to AD Security Group     

    Examples:
      | rbac-role | ad-group |
      | PUA | user-admin |
      | ...  | ... |
