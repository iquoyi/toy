class Contract < Sequel::Model
  def validate
    super
    errors.add(:start_date, "can't be empty") if start_date.blank?
    errors.add(:end_date, "can't be empty") if end_date.blank?
  end
end
