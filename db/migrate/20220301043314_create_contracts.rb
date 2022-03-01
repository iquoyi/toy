Sequel.migration do
  change do
    create_table :contracts do
      primary_key :id
      Date :start_date
      Date :end_date
      String :legal
    end
  end
end
