class Employee < Sequel::Model
  plugin :bitemporal, version_class: EmployeeVersion

  one_to_many :contracts

  dataset_module do
    def by_name(name = nil)
      return eager_graph(:current_version).all unless name

      # Note the | operator for OR (https://github.com/jeremyevans/sequel/blob/master/doc/querying.rdoc#label-SQL-3A-3AExpression)
      eager_graph(:current_version).where(
        Sequel.like(Sequel.function(:lower, :first_name), "%#{name.downcase}%") |
        Sequel.like(Sequel.function(:lower, :last_name), "%#{name.downcase}%")
      ).all
    end

    # dataset for employees with contract fields
    def with_contracts
      # eager_graph(:current_version, contracts: :current_version)
      association_left_join(:current_version, contracts: :current_version)
    end

    # dataset for employees with a current contract fields
    def with_current_contract
      today = Time.zone.today
      with_contracts.where(Sequel.lit("start_date <= ? AND end_date >= ?", today, today))
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
