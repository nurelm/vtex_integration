require 'spec_helper'

describe VTEXEndpoint do
  let(:inventory) { Factories.inventory }
  let(:product) { Factories.product }
  let(:params) { Factories.parameters }

  describe '/get_orders' do
    context 'success' do
      it 'retrive orders' do
        message = {
          request_id: '123456',
          parameters: params
        }.to_json

        VCR.use_cassette('get_orders') do
          post '/get_orders', message, auth
          expect(last_response.status).to eq(200)
          expect(last_response.body).to match /orders were retrieved/
        end
      end
    end
  end

  describe '/set_inventory' do
    context 'success' do
      it 'imports new inventories' do
        message = {
          request_id: '123456',
          inventory: inventory,
          parameters: params
        }.to_json

        VCR.use_cassette('set_inventory') do
          post '/set_inventory', message, auth

          expect(last_response.status).to eq(200)
          expect(last_response.body).to match /was sent to VTEX Storefront/
        end
      end
    end
  end

  describe '/add_product' do
    context 'success' do
      it 'imports new products' do
        message = {
          request_id: '123456',
          product: product,
          parameters: params
        }.to_json

        VCR.use_cassette('add_product') do
          post '/add_product', message, auth

          expect(last_response.status).to eq(200)
          expect(last_response.body).to match /were sent to VTEX Storefront/
        end
      end
    end
  end

  describe '/get_products' do
    context 'success' do
      it 'brings products' do
        message = { parameters: params }

        VCR.use_cassette('get_products') do
          post '/get_products', message.to_json, auth
          expect(json_response[:summary]).to match /received from VTEX/
          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
