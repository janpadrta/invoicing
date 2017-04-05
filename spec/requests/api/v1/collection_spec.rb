# frozen_string_literal: true

require 'rails_helper'

describe 'API collection', type: :request do
  it 'should send collection of invoices' do
    FactoryGirl.create_list(:invoice, 10)

    get '/api/v1/invoices'

    json = JSON.parse(response.body)

    expect(response).to be_success
    expect(json['invoices'].length).to eq(10)
  end
end
