Sequel.migration do
  change do
    create_table(:contracts) do
      primary_key :id, :type=>"INTEGER"
      column :start_date, "date"
      column :end_date, "date"
      column :legal, "varchar(255)"
    end
    
    create_table(:employees) do
      primary_key :id, :type=>"INTEGER"
      column :first_name, "varchar(255)"
      column :last_name, "varchar(255)"
      column :birthday, "date"
      column :address, "TEXT"
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
                end
              end
