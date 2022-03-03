class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees or /employees.json
  def index
    @employees_dateset = Employee.with_current_version
    @employees_dateset = @employees_dateset.by_first_name(params[:first_name]) if params[:first_name]
    @employees_dateset = @employees_dateset.by_address(params[:address]) if params[:address]
    @employees = @employees_dateset.all
  end

  # GET /employees/1 or /employees/1.json
  def show
    @versions = @employee.versions_dataset.order(:id).all
    @contracts = @employee.contracts
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees or /employees.json
  def create
    @employee = Employee.new

    if @employee.update_attributes(employee_params)
      redirect_to employee_url(@employee.id), notice: "Employee was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /employees/1 or /employees/1.json
  def update
    if @employee.update_attributes(employee_params)
      redirect_to employee_url(@employee.id), notice: "Employee was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /employees/1 or /employees/1.json
  def destroy
    @employee.destroy

    respond_to do |format|
      format.html { redirect_to employees_url, notice: "Employee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :birthday, :address)
  end
end
