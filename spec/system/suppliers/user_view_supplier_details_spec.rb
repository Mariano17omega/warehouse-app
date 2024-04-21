require 'rails_helper'

describe 'Usuario vê detalhes do fornecedore' do
  it 'a partir da tela inicial' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    #  Assert
    expect(page).to have_content 'ACME LTDA'
    expect(page).to have_content 'Documento: 29452204000145'
    expect(page).to have_content 'Endereço: Av das Plamas, 100 - Bauru - SP'
    expect(page).to have_content 'Email: contato@acme.com'

  end

  it 'e volta para a tela inicial' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Voltar'
    #  Assert
    expect(current_path).to eq suppliers_path

  end


end
