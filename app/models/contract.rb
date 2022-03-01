class Contract < Sequel::Model

  many_to_one :employee

  plugin :bitemporal, version_class: ContractVersion
end
