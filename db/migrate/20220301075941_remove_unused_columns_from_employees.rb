# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table :employees do
      drop_column :first_name
      drop_column :last_name
      drop_column :birthday
      drop_column :address
    end
  end

  down do
    alter_table :employees do
      add_column :first_name, :string
      add_column :last_name, :string
      add_column :birthday, :date
      add_column :address, :text
    end
  end
end
