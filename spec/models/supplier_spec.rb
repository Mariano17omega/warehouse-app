require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'Apresenta' do
      it 'Falso quando o corporate_name está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: '', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o brand_name está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: '', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o registration_number está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o full_address está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: '', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o city está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: '', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o state está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: '', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o email está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: '' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end


      context 'Apresenta' do

        it 'Falso quando o corporate_name já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'Spark', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end
        it 'Falso quando o email já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@acme.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

        it 'Falso quando o brand_name já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'ACME', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

        it 'Falso quando o registration_number já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '29452204000145',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

      end

    end
  end
end
