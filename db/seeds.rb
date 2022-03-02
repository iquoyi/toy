# Seed Data

[
  { first_name: 'Zhang', last_name: 'San', birthday: '2000-01-01', address: 'Fake street' },
  { first_name: 'Li', last_name: 'Si', birthday: '2000-12-31', address: 'Fake street' }
].each do |employee_item|
  employee = Employee.new
  employee.update_attributes(employee_item)

  [
    { start_date: '2021-02-01', end_date: '2021-03-01', legal: 'Employer' },
    { start_date: '2021-03-02', end_date: '2024-03-01', legal: 'Leader' }
  ].each do |contract_item|
    contract = Contract.new(employee_id: employee.id)
    contract.update_attributes(contract_item)
  end
end
