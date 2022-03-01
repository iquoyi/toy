class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion

  one_to_many :contracts
end
