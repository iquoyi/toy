Sequel.migration do
  change do
    create_table :employee_versions do
      primary_key :id
      Integer :master_id
      Date :valid_from
      Date :valid_to
      String :first_name
      String :last_name
      Date :birthday
      Text :address
      Date :created_at
      Date :expired_at
    end
  end
end
