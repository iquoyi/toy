Sequel.migration do
  change do
    create_table :employees do
      primary_key :id
      String :first_name
      String :last_name
      Date :birthday
      Text :address
    end
  end
end
