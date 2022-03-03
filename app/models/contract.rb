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
  end

  def siblings_versions
    ContractVersion.where(master_id: siblings.all.pluck(:id))
  end

  # records include self
  def siblings
    employee.contracts_dataset
  end
end
