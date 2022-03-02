class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion

  one_to_many :contracts

  dataset_module do
    def with_current_contracts
      # TODO
    end
  end
end
