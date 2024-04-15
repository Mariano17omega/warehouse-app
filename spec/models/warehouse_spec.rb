require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'Apresenta' do
      it 'Falso quando o name está vazio' do
        # Assert
        warehouse = Warehouse.new(name: '', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

        # Act 
        result = warehouse.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o code está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: '',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false        
      end

      it 'Falso quando a city está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: '', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando a area está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o address está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: ''  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o cep está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando a description está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: '')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end
    end





    context 'Apresenta' do

      it 'Falso quando o CODE já está sendo usado' do
        # Assert
        first_warehouse = Warehouse.create(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
          
          
      second_warehouse = Warehouse.new(name: 'Maceio', code: 'SDU',  city: 'Maceio', area: '50000', address: 'Tabuleiro do Pinto, Rio Largo' , cep: '57100-000' , description: 'Galpão do aeroporto Internacional de Maceió' )

        # Act 
        #result = second_warehouse.valid?
        # Assert
        #expect(result).to eq false  
        expect(second_warehouse).not_to be_valid
      end
    end

  end
end
