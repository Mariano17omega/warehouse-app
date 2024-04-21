class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update]

  def index
    @suppliers= Supplier.all
  end

  def show; end

  def new
    @supplier = Supplier.new()
  end


  def create
    # 1 - Recebe os dados enviados
    #supplier_params

    # 2 - Cria um novo galpão no banco de dados
    @supplier = Supplier.new(supplier_params)

    #    3 - Redireciona para a tela inicial
        if @supplier.save()
          redirect_to suppliers_path, notice: 'Fornecedor cadastrado com sucesso.'
        else
          flash.now[:notice] = 'Fornecedor não cadastrado.'
          render 'new'
        end
      end

      def edit; end

      def update
        #supplier_params

        if @supplier.update(supplier_params)
          redirect_to supplier_path(  @supplier.id ), notice: 'Fornecedor editado com sucesso.'
        else
          flash[:notice] = 'Não foi possível editar o Fornecedor.'
          render 'edit'
        end
      end

      private

      def set_supplier
        @supplier =  Supplier.find(params[:id])
      end

      def supplier_params
        params.require(:supplier).permit( :corporate_name, :brand_name, :registration_number, :full_address,
                       :city, :state, :email)
      end

end
