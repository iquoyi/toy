class Contract < Sequel::Model
  plugin :bitemporal, version_class: ContractVersion
  plugin :validation_helpers

  # rubocop:disable Layout/LineLength
  DATE_REGEXP = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/.freeze
  # rubocop:enable Layout/LineLength

  many_to_one :employee

  def validate
    super
    validates_presence [:start_date, :end_date]
    validates_format DATE_REGEXP, [:start_date, :end_date]
    validates_overlap(start_date, end_date)
  end

  def validates_overlap(start_date, end_date)
    overlap = siblings_versions.where(Sequel.lit("start_date <= ? AND end_date >= ?", end_date, start_date)).any?
    return unless overlap

    msg = "can't overlap with the period[#{start_date}..#{end_date}]"
    errors.add(:start_date, msg)
    errors.add(:end_date, msg)

    # sql = Sequel.lit("contract_versions.end_date >= ? AND contract_versions.end_date < ?", start_date, end_date)
    # left_overlap = employee_contracts_with_versions_dataset.where(sql).first

    # left_overlap = siblings_versions.where(Sequel.lit("end_date > ?", start_date)).first
    # if left_overlap
    #   errors.add(:start_date, "can't overlap with the period[#{range}]")
    #   return
    # end

    # right_overlap = siblings_versions.where(Sequel.lit("start_date < ?", end_date)).first
    # errors.add(:end_date, "can't overlap with the period[#{range}]") if right_overlap

    # complete_overlap = siblings_versions.where("start_date < ? AND end_date > ?", start_date, end_date).first
    # return unless complete_overlap

    # errors.add(:start_date, "can't overlap with the period[#{range}]")
    # errors.add(:end_date, "can't overlap with the period[#{range}]")

    # return if ContractVersion.where(start_date: range, end_date: range).empty?

    # errors.add(:start_date, "can't be overlap")
    # errors.add(:end_date, "can't be overlap")
    # sql = Sequel.lit("contract_versions.end_date IN ?", range)
  end

  # def employee_contracts_with_versions_dataset
  #   employee.contracts_dataset.join(:contract_versions, master_id: :id)
  # end

  def siblings_versions
    ContractVersion.where(master_id: siblings.all.pluck(:id))
  end

  # records include self
  def siblings
    employee.contracts_dataset
  end
end

# start_date = Date.parse('2021-01-01')
# end_date = Date.parse('2021-01-02')
# range = start_date..end_date
# e = Employee.dataset.first
# c = Contract.new(start_date: '2022-03-08', end_date: '2022-03-23', legal: '')
# e.add_contract(c)

# c = Contract.dataset.first
# #<Contract @values={:id=>1, :employee_id=>1}>

# cv = c.versions
# [#<ContractVersion @values={:id=>1, :master_id=>1, :valid_from=>Wed, 02 Mar 2022, :valid_to=>Fri, 01 Jan 9999,
#   :start_date=>Tue, 01 Mar 2022, :end_date=>Sat, 05 Mar 2022, :legal=>"Test legal", :created_at=>Wed, 02 Mar 2022,
#   :expired_at=>nil}>]

# Mon, 28 Feb 2022 => Date.parse('2022-02-28')
# Tue, 01 Mar 2022 => Date.parse('2022-03-01')
# Wed, 02 Mar 2022 => Date.parse('2022-03-02')
# Sat, 05 Mar 2022 => Date.parse('2022-03-05')
# Sun, 06 Mar 2022 => Date.parse('2022-03-06')

# range1 = Date.parse('2022-02-28')..Date.parse('2022-03-02')
# range2 = Date.parse('2022-03-02')..Date.parse('2022-03-06')
# range3 = Date.parse('2022-02-28')..Date.parse('2022-03-06')

# c.versions_dataset.where(start_date: range1)
#

# e = c.employee
# c_ids = e.contracts_dataset.select(:id).all
# ContractVersion.where(master_id: e.contracts_dataset.select(:id), start_date: range1)

# cv = ContractVersion.where(start_date: range).first
