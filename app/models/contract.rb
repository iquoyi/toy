class Contract < Sequel::Model
  plugin :bitemporal, version_class: ContractVersion

  many_to_one :employee
end
