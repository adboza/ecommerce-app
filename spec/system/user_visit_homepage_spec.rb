require 'rails_helper'
describe 'Usuário visita tela inicial'do
  it 'e vê galpões' do
    #Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    #Act
    visit root_path
    #Assert
    expect(page).to have_content 'E-commerce App'
    expect(page).to have_content 'Aeroporto Cwb'
    expect(page).to have_content 'Aeroporto SP'
  end

  it 'e não existem galpões' do
     #Arrange
     fake_response = double("faraday_response", status: 200, body: "[]")
     allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
     #Act
     visit root_path
     #Assert
     expect(page).to have_content 'Nenhum galpão encontrado'
  end

  it 'e vê detalhes de galpão' do
    #Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/1').and_return(fake_response)

    #Act
    visit root_path
    click_on 'Aeroporto SP'
    #Assert
    expect(page).to have_content 'Galpão GRU - Aeroporto SP'
    expect(page).to have_content 'Guarulhos'
    expect(page).to have_content '100000 m2'
    expect(page).to have_content 'Avenida do Aeroporto, 1000 - CEP 15000-000'
    expect(page).to have_content 'Galpão destinado para cargas internacionais'
  end
  it 'e não é possível carregar galpão' do
    #Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double("faraday_response", status: 500, body: "{}")
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/1').and_return(fake_response)

    #Act
    visit root_path
    click_on 'Aeroporto SP'
    #Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar galpão'    
  end
end