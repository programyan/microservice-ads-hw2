Sequel.application_timezone = :local
Sequel.database_timezone = :utc
Sequel::Database.extension :pagination
Sequel::Model.plugin :timestamps, update_on_create: true
