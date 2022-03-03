require "rails_helper"

RSpec.describe ContractsController, type: :routing do
  describe "routing" do
    let(:employee) { Employee.create(first_name: 'First', last_name: 'Last') }

    # it "routes to #index" do
    #   expect(get: "/employees/#{employee.id}/contracts").to route_to("contracts#index")
    # end

    it "routes to #new" do
      expect(get: "/employees/#{employee.id}/contracts/new").to route_to("contracts#new", employee_id: employee.id.to_s)
    end

    it "routes to #show" do
      expect(
        get: "/employees/#{employee.id}/contracts/1"
      ).to route_to("contracts#show", employee_id: employee.id.to_s, id: "1")
    end

    it "routes to #edit" do
      expect(
        get: "/employees/#{employee.id}/contracts/1/edit"
      ).to route_to("contracts#edit", employee_id: employee.id.to_s, id: "1")
    end

    it "routes to #create" do
      expect(post: "/employees/#{employee.id}/contracts").to route_to("contracts#create", employee_id: employee.id.to_s)
    end

    it "routes to #update via PUT" do
      expect(
        put: "/employees/#{employee.id}/contracts/1"
      ).to route_to("contracts#update", employee_id: employee.id.to_s, id: "1")
    end

    it "routes to #update via PATCH" do
      expect(
        patch: "/employees/#{employee.id}/contracts/1"
      ).to route_to("contracts#update", employee_id: employee.id.to_s, id: "1")
    end

    it "routes to #destroy" do
      expect(
        delete: "/employees/#{employee.id}/contracts/1"
      ).to route_to("contracts#destroy", employee_id: employee.id.to_s, id: "1")
    end
  end
end
