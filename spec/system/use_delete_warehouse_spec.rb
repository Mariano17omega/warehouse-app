require 'rails_helper'

describe 'Usuario remove um galpão' do
  it 'Com sucesso' do
    # Arrange
    Warehouse.create(name: 'Maceio', code: 'MCZ',  city: 'Maceio', area: '50000', address: 'Tabuleiro do Pinto, Rio Largo' , cep: '57100-000' , description: 'Galpão do aeroporto Internacional de Maceió' )

    # Act
    visit root_path
    click_on 'Maceio'
    click_on 'Remover'
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso'
    expect(page).not_to have_content 'Maceio'
    expect(page).not_to have_content 'MCZ'

  end

end
