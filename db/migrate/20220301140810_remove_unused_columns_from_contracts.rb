# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :contracts do
      drop_column :start_date
      drop_column :end_date
      drop_column :legal
    end
  end

  down do
    alter_table :contracts do
      add_column :start_date, :date
      add_column :end_date, :date
      add_column :legal, :text
    end
  end
end
