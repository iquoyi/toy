class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion
end
