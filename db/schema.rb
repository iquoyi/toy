Sequel.migration do
  change do
    create_table(:contracts) do
      primary_key :id, :type=>"INTEGER"
      column :start_date, "date"
      column :end_date, "date"
      column :legal, "varchar(255)"
    end
    
    create_table(:employee_versions) do
      primary_key :id, :type=>"INTEGER"
      column :master_id, "INTEGER"
      column :valid_from, "date"
      column :valid_to, "date"
      column :first_name, "varchar(255)"
      column :last_name, "varchar(255)"
      column :birthday, "date"
      column :address, "TEXT"
      column :created_at, "date"
      column :expired_at, "date"
    end
    
    create_table(:employees) do
      primary_key :id, :type=>"INTEGER"
    end
    
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
  end
end
              Sequel.migration do
                change do
                  self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20220228074601_create_employees.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20220301043314_create_contracts.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20220301075542_create_employee_versions.rb')"
self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20220301075941_remove_unused_columns_from_employees.rb')"
                end
              end
