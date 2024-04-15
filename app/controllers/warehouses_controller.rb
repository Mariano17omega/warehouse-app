class WarehousesController < ApplicationController
  def show
    @warehouse =  Warehouse.find(params[:id])
  end
    
  def new
    @warehouse = Warehouse.new()
  end

  def create
#    1 - Recebe os dados enviados 
    warehouse_params = params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)
    
#    2 - Cria um novo galpão no banco de dados
    @warehouse = Warehouse.new(warehouse_params)
    
#    3 - Redireciona para a tela inicial
    if @warehouse.save()
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso.' 
    else
      flash.now[:notice] = 'Galpão não cadastrado.' 
      render 'new'
    end
    
    #flash[:notice] = 'Galpão cadastrado com sucesso.' 
    #redirect_to root_path 
  end

end