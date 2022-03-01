class Contract < Sequel::Model
  plugin :bitemporal, version_class: ContractVersion
end
