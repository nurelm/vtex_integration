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
    it 'brings products' do
      message = {
        parameters: params.merge(vtex_products_since: "2014-11-06T11:25:20Z")
      }

      VCR.use_cassette("1415306393") do
        post '/get_products', message.to_json, auth
        expect(json_response[:summary]).to match /from VTEX/
        expect(last_response.status).to eq(200)
        expect(json_response[:products].count).to be >= 1
      end
    end

    it "brings no products" do
      message = {
        parameters: params.merge(vtex_products_since: "2014-11-06T21:25:20Z")
      }

      VCR.use_cassette("no_products_1415323854") do
        post '/get_products', message.to_json, auth
        expect(json_response[:summary]).to eq nil
        expect(last_response.status).to eq(200)
      end
    end
  end
end
