class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion

  one_to_many :contracts

  dataset_module do
    # dataset for employees with contract fields
    def with_contracts
      association_left_join(:current_version, contracts: :current_version)
    end

    # dataset for employees with a current contract fields
    def with_current_contract
      today = Time.zone.today
      with_contracts.where(Sequel.lit("start_date <= ? AND end_date >= ?", today, today))
    end

    def by_first_name(first_name)
      with_current_contract.where(Sequel.like(Sequel.function(:lower, :first_name), "%#{first_name.downcase}%"))
    end

    def by_last_name(last_name)
      with_current_contract.where(Sequel.like(Sequel.function(:lower, :last_name), "%#{last_name.downcase}%"))
    end

    def by_birthday(birthday)
      with_current_contract.where(Sequel.lit("birthday = ?", birthday))
    end

    def by_address(address)
      with_current_contract.where(Sequel.like(Sequel.function(:lower, :address), "%#{address.downcase}%"))
    end

    def by_date(date)
      with_current_contract.where(Sequel.lit("start_date <= ? AND end_date >= ?", date, date))
    end

    def by_legal(legal)
      with_current_contract.where(Sequel.like(Sequel.function(:lower, :legal), "%#{legal.downcase}%"))
    end
  end
end

# Employee.association_left_join(:current_version, contracts: :current_version)
# SELECT * FROM `employees`
# LEFT JOIN `employee_versions` AS 'employee_current_version'
#   ON (
#     (`employee_current_version`.`master_id` = `employees`.`id`)
#     AND (`employee_current_version`.`created_at` <= '2022-03-02 20:23:29.981147')
#     AND (
#       (`employee_current_version`.`expired_at` IS NULL)
#       OR (`employee_current_version`.`expired_at` > '2022-03-02 20:23:29.981482')
#     )
#     AND (`employee_current_version`.`valid_from` <= '2022-03-02 20:23:29.981696')
#     AND (`employee_current_version`.`valid_to` > '2022-03-02 20:23:29.981869')
#   )
# LEFT JOIN `contracts`
#   ON (`contracts`.`employee_id` = `employees`.`id`)
# LEFT JOIN `contract_versions` AS 'contract_current_version'
#   ON (
#     (`contract_current_version`.`master_id` = `contracts`.`id`)
#     AND (`contract_current_version`.`created_at` <= '2022-03-02 20:23:29.982078')
#     AND (
#       (`contract_current_version`.`expired_at` IS NULL)
#       OR (`contract_current_version`.`expired_at` > '2022-03-02 20:23:29.982259')
#     )
#     AND (`contract_current_version`.`valid_from` <= '2022-03-02 20:23:29.982431')
#     AND (`contract_current_version`.`valid_to` > '2022-03-02 20:23:29.982598')
#   )
