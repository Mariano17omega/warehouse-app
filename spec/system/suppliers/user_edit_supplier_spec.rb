require 'rails_helper'

describe 'Usuario Editar um fornecedor' do
  it 'a partir do menu' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACMES', registration_number: '29452204000145',
    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACMES'
    click_on 'Editar'
    #  Assert
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'E-mail'

  end

  it 'com sucesso' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACMES', registration_number: '29452204000145',
    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACMES'
    click_on 'Editar'

    fill_in 'Nome Fantasia',	with: 'STARK'
    fill_in 'Razão Social',	with: 'STARK Industires LTDA'
    fill_in 'Endereço',	with: 'Nova York, T10'
    fill_in 'Cidade',	with: 'Nova York'
    fill_in 'Estado',	with: 'NY'
    fill_in 'E-mail',	with: 'contato@stark.com'
    click_on 'Enviar'

    #  Assert
    #expect(current_path).to eq root_path
    expect(page).to have_content 'Fornecedor editado com sucesso.'
    expect(page).to have_content 'STARK Industires LTDA'
    expect(page).to have_content 'Documento: 29452204000145'
    expect(page).to have_content 'Endereço: Nova York, T10 - Nova York - NY'
    expect(page).to have_content 'contato@stark.com'

  end


  it 'com dados incopletos' do
    #  Arrange
    Supplier.create!(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '52654414000138',
    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Spark'
    click_on 'Editar'

    fill_in 'Nome Fantasia',	with: ''
    fill_in 'Razão Social',	with: ''
    fill_in 'Endereço',	with: 'Nova York, T10'
    fill_in 'Cidade',	with: 'Nova York'
    fill_in 'Estado',	with: 'NY'
    fill_in 'E-mail',	with: 'contato@stark.com'
    fill_in 'CNPJ',	with: ''
    click_on 'Enviar'

    #  Assert
    expect(page).to have_content 'Não foi possível editar o Fornecedor'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end
