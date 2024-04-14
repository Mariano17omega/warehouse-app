class WarehousesController < ApplicationController
  def show
    @warehouse =  Warehouse.find(params[:id])
  end
    
  def new
  end

  def create
#    1 - Recebe os dados enviados 
    warehouse_params = params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)
    
#    2 - Cria um novo galpão no banco de dados
    w=Warehouse.new(warehouse_params)
    w.save()
#    3 - Redireciona para a tela inicial
    redirect_to root_path
  end

end