require 'rails_helper'

describe 'Usuario edita um galpão' do
  it 'a partir da tela inicial' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
                address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    # Assert

    expect(page).to have_field 'Nome', with: 'Rio'
    expect(page).to have_field 'Descrição', with: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro'
    expect(page).to have_field 'Código' , with: 'SDU'
    expect(page).to have_field 'Endereço' , with: 'Ilha do Governador'
    expect(page).to have_field 'Cidade', with: 'Rio de Janeiro'
    expect(page).to have_field 'CEP' , with: '21941-900'
    expect(page).to have_field 'Área', with: '60000'
  end

  it 'com sucesso' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
                address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'

    fill_in 'Nome',	with: 'São Paulo'
    fill_in 'Cidade',	with: 'São Paulo'
    fill_in 'Endereço',	with: 'Avenida qualquer'
    fill_in 'Área',	with: '6666666'
    click_on 'Enviar'
    # Assert
    expect(page).to have_content 'Galpão Atualizado com sucesso'
    expect(page).to have_content 'Nome: São Paulo'
    expect(page).to have_content 'Área: 6666666 m²'
    expect(page).to have_content 'Endereço: Avenida qualquer'
    expect(page).to have_content 'Cidade: São Paulo'

    end

    it 'e mantem os campos obrigadorios' do
      # Arrange
      warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
                  address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

      # Act
      visit root_path
      click_on 'Rio'
      click_on 'Editar'

      fill_in 'Nome',	with: ''
      fill_in 'Cidade',	with: 'São Paulo'
      fill_in 'Endereço',	with: ''
      fill_in 'Área',	with: ''
      click_on 'Enviar'
      # Assert
      expect(page).to have_content 'Não foi possivel atualizar o galpão'
      end

end
