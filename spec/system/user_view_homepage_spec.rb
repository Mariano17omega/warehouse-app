require 'rails_helper'

describe 'Usuario visita tela inicial' do
  it 'e vê o nome do app' do
    # Arrange
    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Galpões & Estoque')
  end 

  it 'e vê os galpões cadrastrados' do
    # Arrange
    Warehouse.create(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000')
    Warehouse.create(name: 'Maceio', code: 'MCZ',  city: 'Maceio', area: '50000')

    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Rio')
    expect(page).to have_content('SDU')
    expect(page).to have_content('Rio de Janeiro')
    expect(page).to have_content('60000 m²')

    expect(page).to have_content('Maceio')
    expect(page).to have_content('MCZ')
    expect(page).to have_content('Maceio')
    expect(page).to have_content('50000 m²')
  end 
end