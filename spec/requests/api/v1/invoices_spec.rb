# frozen_string_literal: true

require 'rails_helper'

describe 'API collection', type: :request do
  let!(:invoices) { create_list(:invoice, 10) }

  it 'should response with 200' do
    get '/api/v1/invoices'

    expect(response).to be_success
  end

  it 'should have 10 records' do
    get '/api/v1/invoices'

    expect(jsoned['invoices'].length).to eq(10)
  end
end
