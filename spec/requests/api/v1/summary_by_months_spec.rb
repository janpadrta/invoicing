# frozen_string_literal: true

require 'rails_helper'

describe 'API collection', type: :request do
  it 'should send collection of invoices' do
    FactoryGirl.create(:invoice, price: 1000.0, vat_rate: 5.0, issued_at: '2017-01-03 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime)

    get '/api/v1/summary/months'

    json = JSON.parse(response.body)

    expect(response).to be_success
    json['summary'].should == [
      { 'date' => '2017-01-01', 'price_with_vat' => '4548.0', 'price' => '4300.0' },
      { 'date' => '2017-02-01', 'price_with_vat' => '4320.0', 'price' => '4000.0' },
      { 'date' => '2017-03-01', 'price_with_vat' => 0.0, 'price' => 0.0 },
      { 'date' => '2017-04-01', 'price_with_vat' => '8734.0', 'price' => '8200.0' }
    ]
  end
end
