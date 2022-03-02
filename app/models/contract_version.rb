class ContractVersion < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence [:start_date, :end_date]
  end
end
