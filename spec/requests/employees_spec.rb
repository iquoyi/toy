require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/employees", type: :request do
  # Employee. As you add validations to Employee, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      first_name: 'First Name',
      last_name: 'Last Name',
      birthday: '2022-03-01',
      address: 'Address'
    }
  end

  let(:invalid_attributes) do
    {
      first_name: '',
      last_name: '',
      birthday: '2022-03-01',
      address: 'Address'
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      Employee.create valid_attributes
      get employees_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      employee = Employee.create valid_attributes
      get employee_url(employee.id)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_employee_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      employee = Employee.create valid_attributes
      get edit_employee_url(employee.id)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Employee" do
        expect do
          post employees_url, params: { employee: valid_attributes }
        end.to change(Employee, :count).by(1)
      end

      it "redirects to the created employee" do
        post employees_url, params: { employee: valid_attributes }
        expect(response).to redirect_to(employee_url(Employee.last.id))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Employee" do
        expect do
          post employees_url, params: { employee: invalid_attributes }
        end.to change(Employee, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post employees_url, params: { employee: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) do
        {
          first_name: 'New First Name'
        }
      end

      it "updates the requested employee" do
        employee = Employee.new
        employee.update_attributes valid_attributes
        patch employee_url(employee.id), params: { employee: new_attributes }
        assert_equal new_attributes[:first_name], employee.current_version(reload: true).first_name
      end

      it "redirects to the employee" do
        employee = Employee.new
        employee.update_attributes valid_attributes
        patch employee_url(employee.id), params: { employee: new_attributes }
        employee.reload
        expect(response).to redirect_to(employee_url(employee.id))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        employee = Employee.create valid_attributes
        patch employee_url(employee.id), params: { employee: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested employee" do
      employee = Employee.new
      employee.update_attributes valid_attributes
      expect do
        delete employee_url(employee.id)
      end.to change { Employee.with_current_or_future_versions.all.size }.by(-1)
    end

    it "redirects to the employees list" do
      employee = Employee.create valid_attributes
      delete employee_url(employee.id)
      expect(response).to redirect_to(employees_url)
    end
  end
end
