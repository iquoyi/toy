class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :edit, :update, :destroy]

  # GET /contracts or /contracts.json
  def index
    @contracts = Contract.all
  end

  # GET /contracts/1 or /contracts/1.json
  def show
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts or /contracts.json
  def create
    @contract = Contract.new(contract_params)

    if @contract.update_attributes(contract_params)
      redirect_to contract_url(@contract.id), notice: "Contract was successfully created."
    else
      render :new
    end
  end

  # PATCH/PUT /contracts/1 or /contracts/1.json
  def update
    @contract.set(contract_params)

    if @contract.update_attributes(contract_params)
      redirect_to contract_url(@contract.id), notice: "Contract was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /contracts/1 or /contracts/1.json
  def destroy
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to contracts_url, notice: "Contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contract
    @contract = Contract.find(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contract_params
    params.require(:contract).permit(:start_date, :end_date, :legal)
  end
end
