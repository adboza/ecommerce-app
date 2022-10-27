require  'rails_helper'
describe Warehouse do
  context '.all' do
    it 'deve retornar todos os galpões' do
      #Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
      #Act
      result = Warehouse.all 
      #Assert
      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Aeroporto SP'      
      expect(result[0].code).to eq 'GRU'
      expect(result[0].cep).to eq '15000-000'
      expect(result[0].address).to eq 'Avenida do Aeroporto, 1000'
      expect(result[0].description).to eq 'Galpão destinado para cargas internacionais'
      expect(result[0].area).to eq 100000

      expect(result[1].name).to eq 'Aeroporto Cwb'
      expect(result[1].code).to eq 'CWB'
    end
    it 'deve retornar vazio se a API está indisponível' do
      #Arrange
      fake_response = double("faraday_response", status: 500, body: "{ error: 'Erro ao obter datos' }")
      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
      #Act
      result = Warehouse.all
      #Assert
      expect(result).to eq []
    end
  end
end