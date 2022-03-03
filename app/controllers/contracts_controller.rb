class ContractsController < ApplicationController
  before_action :set_employee
  before_action :set_contract, only: [:show, :edit, :update, :destroy]

  # GET /contracts
  def index
    @contracts = @employee.contracts
  end

  # GET /contracts/1
  def show
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts
  def create
    @contract = Contract.new(employee_id: @employee.id)

    if @contract.update_attributes(contract_params)
      # @employee.add_contract(@contract)
      redirect_to employee_contract_url(@employee.id, @contract.id), notice: "Contract was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /contracts/1
  def update
    @contract.set(contract_params)

    if @contract.update_attributes(contract_params)
      # @employee.add_contract(@contract)
      redirect_to employee_contract_url(@employee.id, @contract.id), notice: "Contract was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /contracts/1
  def destroy
    @contract.destroy

    redirect_to employee_url(@employee.id), notice: "Contract was successfully destroyed."
  end

  private

  def set_employee
    @employee = Employee.find(id: params[:employee_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_contract
    @contract = Contract.find(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contract_params
    params.require(:contract).permit(:start_date, :end_date, :legal)
  end
end
