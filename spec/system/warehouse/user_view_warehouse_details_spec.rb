require 'rails_helper'

describe 'Usuario vê detalhes de um galpão' do
  it 'e ve informações adicionais' do
    # Arrange
    w = Warehouse.new(name: 'Aeroporto SP', code: 'GRU',  city: 'Guarulhos', area: '100000', address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    w.save
    # Act
    visit root_path
    click_on('Aeroporto SP')
    # Assert
    expect(page).to have_content('Galpão GRU')
    expect(page).to have_content('Nome: Aeroporto SP')
    expect(page).to have_content('Cidade: Guarulhos')
    expect(page).to have_content('Área: 100000 m²')
    expect(page).to have_content('Endereço: Avenida do Aeroporto, 1000 CEP: 15000-000')
    expect(page).to have_content('Galpão destinado para cargas internacionais')
    end

    it 'e volta para a tela inicial' do 
      # Arrange
      w = Warehouse.new(name: 'Aeroporto SP', code: 'GRU',  city: 'Guarulhos', area: '100000', address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
      w.save
      # Act
      visit root_path
      click_on 'Aeroporto SP'
      click_on 'Voltar'
      # Assert
      expect(current_path).to eq(root_path)

    end
end