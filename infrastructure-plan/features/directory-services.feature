Feature: Directory Service Standards AWS

    Scenario Outline: Directory Service Properties
        Given I have acuity_directory_service defined
        Then it must have <property>
        And its value must be <pattern>

        Examples:
        | property | pattern     |
        | edition  | Enterprise  |
        | type     | MicrosoftAD |

    Scenario: Directory Service Subnets
        Given I have aws_directory_service_directory defined
        When it has vpc_settings
        Then it must contain subnet_ids
        And its value must not be null

    Scenario Outline: Directory Ingress Security
        Given I have AWS Security Group defined
        When it has ingress
        Then it must have ingress
        Then it must have <proto> protocol and port <portNumber> for 192.168.0.0/24

        Examples:
        | ProtocolName       | proto | portNumber |
        | LDAPS              | tcp   | 636        |
        | DNS                | tcp   | 53         |
        | Global Catalog SSL | tcp   | 3269       |
       
      
    Scenario Outline: Directory Ingress Security
        Given I have AWS Security Group defined
        When it has ingress
        Then it must have ingress
        Then it must not have <proto> protocol and port <portNumber> for 192.168.0.0/24

        Examples:
        | ProtocolName       | proto | portNumber |
        | LDAP               | tcp   | 389        |
        | Global Catalog     | tcp   | 3268       |
