class Contract < Sequel::Model
  def validate
    super
    errors.add(:start_date, "can't be blank") if start_date.blank?
    errors.add(:end_date, "can't be blank") if end_date.blank?
  end
end
