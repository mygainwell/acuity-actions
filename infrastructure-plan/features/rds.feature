Feature: Persistent SQL Standards

  Scenario: RDS for PostgresSQL
    Must have storage_encrypted
    Must vulnerability scan the migration framework vercode
    backup_retention_period = 7 years for prod
    db-connection-string in aws_secretsmanager_secret
   
   static:
      storage_encrypted = true
      port = 5432
      engine_version = "12.5"
      
      
   variables:
     multi_az
     backup_retention_period
     skip_final_snapshot
     username
     instance_class          = "db.t3.micro"
     allocated_storage       = "20"
     storage_type            = "gp2"
     
   Dipendency Inversion:
    label
    network
    aws_secretsmanager_secret
    
