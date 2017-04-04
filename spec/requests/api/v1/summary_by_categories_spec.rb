# frozen_string_literal: true

require 'rails_helper'

describe 'API collection', type: :request do
  it 'should send collection of invoices' do
    cat1 = FactoryGirl.create(:category, name: 'Category First')
    cat2 = FactoryGirl.create(:category, name: 'Category Second')
    cat3 = FactoryGirl.create(:category, name: 'Category Third')
    FactoryGirl.create(:invoice, category_id: cat1.id, price: 1000.0, vat_rate: 5.0, issued_at: '2017-01-03 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat2.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat3.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat1.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat2.id, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat3.id, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat1.id, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat2.id, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat3.id, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, category_id: cat1.id, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime)

    get '/api/v1/summary/categories'

    json = JSON.parse(response.body)

    expect(response).to be_success
    json['summary'].should == [
      { 'date' => '2017-01-01', 'category' => { 'id' => 1, 'name' => 'Category First' }, 'price_with_vat' => '2216.0', 'price' => '2100.0' },
      { 'date' => '2017-01-01', 'category' => { 'id' => 2, 'name' => 'Category Second' }, 'price_with_vat' => '1166.0', 'price' => '1100.0' },
      { 'date' => '2017-01-01', 'category' => { 'id' => 3, 'name' => 'Category Third' }, 'price_with_vat' => '1166.0', 'price' => '1100.0' },
      { 'date' => '2017-02-01', 'category' => { 'id' => 1, 'name' => 'Category First' }, 'price_with_vat' => 0.0, 'price' => 0.0 },
      { 'date' => '2017-02-01', 'category' => { 'id' => 2, 'name' => 'Category Second' }, 'price_with_vat' => '2160.0', 'price' => '2000.0' },
      { 'date' => '2017-02-01', 'category' => { 'id' => 3, 'name' => 'Category Third' }, 'price_with_vat' => '2160.0', 'price' => '2000.0' },
      { 'date' => '2017-03-01', 'category' => { 'id' => 1, 'name' => 'Category First' }, 'price_with_vat' => 0.0, 'price' => 0.0 },
      { 'date' => '2017-03-01', 'category' => { 'id' => 2, 'name' => 'Category Second' }, 'price_with_vat' => 0.0, 'price' => 0.0 },
      { 'date' => '2017-03-01', 'category' => { 'id' => 3, 'name' => 'Category Third' }, 'price_with_vat' => 0.0, 'price' => 0.0 },
      { 'date' => '2017-04-01', 'category' => { 'id' => 1, 'name' => 'Category First' }, 'price_with_vat' => '4367.0', 'price' => '4100.0' },
      { 'date' => '2017-04-01', 'category' => { 'id' => 2, 'name' => 'Category Second' }, 'price_with_vat' => '2120.0', 'price' => '2000.0' },
      { 'date' => '2017-04-01', 'category' => { 'id' => 3, 'name' => 'Category Third' }, 'price_with_vat' => '2247.0', 'price' => '2100.0' }
    ]
  end
end
