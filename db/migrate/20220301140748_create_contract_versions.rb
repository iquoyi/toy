Sequel.migration do
  change do
    create_table :contract_versions do
      primary_key :id
      Integer :master_id
      Date :valid_from
      Date :valid_to
      Date :start_date
      Date :end_date
      Text :legal
      Date :created_at
      Date :expired_at
    end
  end
end
