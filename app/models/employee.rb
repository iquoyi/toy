class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion

  # def validate
  #   super
  #   errors.add(:first_name, "can't be empty") if first_name.blank?
  #   errors.add(:last_name, "can't be empty") if last_name.blank?
  # end
end
