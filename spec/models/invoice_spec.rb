# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  client_id   :integer
#  category_id :integer
#  number      :integer
#  price       :decimal(, )
#  vat_rate    :decimal(, )
#  issued_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Invoice do
  let(:invoice) { create(:invoice) }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:vat_rate) }
  it { is_expected.to validate_presence_of(:issued_at) }
  it { is_expected.to validate_numericality_of(:number) }
  it { is_expected.to validate_numericality_of(:price) }
  it { is_expected.to validate_numericality_of(:vat_rate) }

  it 'should create invoice (and client and category)' do
    input = { 'client name' => 'Braden Bernier', 'client company number' => '5466002685', 'invoice number' => '20160003', 'invoice price' => '33366.21', 'invoice vat rate' => '15', 'invoice issued at' => '2016-05-22T18:47:31+02:00', 'category name' => 'rent' }
    ret = Invoice.import(input)
    ret.should be_truthy
    Client.first.name.should == 'Braden Bernier'
    Client.first.company_number.should == 5_466_002_685
    Category.first.name.should == 'rent'
    inv = Invoice.first
    inv.number.should == 20_160_003
    inv.price.should == 33_366.21
    inv.vat_rate.should == 15
    inv.issued_at.should == '2016-05-22 16:47:31'.to_datetime
  end

  it 'should says wrong client' do
    input = { 'client name' => '', 'client company number' => '5466002685', 'invoice number' => '20160003', 'invoice price' => '33366.21', 'invoice vat rate' => '15', 'invoice issued at' => '2016-05-22T18:47:31+02:00', 'category name' => 'rent' }
    ret = Invoice.import(input)
    ret.should == 'Wrong client parameters.'
  end

  it 'should says wrong category' do
    input = { 'client name' => 'Braden Bernier', 'client company number' => '5466002685', 'invoice number' => '20160003', 'invoice price' => '33366.21', 'invoice vat rate' => '15', 'invoice issued at' => '2016-05-22T18:47:31+02:00', 'category name' => '' }
    ret = Invoice.import(input)
    ret.should == 'Wrong category parameters.'
  end

  it 'should says wrong invoice' do
    input = { 'client name' => 'Braden Bernier', 'client company number' => '5466002685', 'invoice number' => '', 'invoice price' => '33366.21', 'invoice vat rate' => '15', 'invoice issued at' => '2016-05-22T18:47:31+02:00', 'category name' => 'rent' }
    ret = Invoice.import(input)
    ret.should == 'Wrong Invoice parameters.'
  end

  it 'should correctly says price with vat' do
    inv = FactoryGirl.create(:invoice, price: 1000.0, vat_rate: 11.0)
    inv.multiplier_vat_rate.should == 1.11
    inv.price_with_vat.should == 1110.0
  end

  it 'should correctly return collection for json' do
    cli1 = FactoryGirl.create(:client, id: 1, name: 'Client First', company_number: 123)
    cli2 = FactoryGirl.create(:client, id: 2, name: 'Client Second', company_number: 456)
    cat = FactoryGirl.create(:category, id: 1, name: 'Category First')
    FactoryGirl.create(:invoice, id: 1, client_id: cli1.id, category_id: cat.id, number: 321, price: 1000.0, vat_rate: 5.0, issued_at: '2017-04-03 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, id: 2, client_id: cli2.id, category_id: cat.id, number: 654, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    Invoice.collection.should == {invoices: [
      { id: 1, invoice_number: 321, price_with_vat: 1050.0, price: 1000.0, vat_rate: 5.0, issued_at: '2017-04-03T13:00:00+00:00', client: { id: 1, name: 'Client First' }, category: { id: 1, name: 'Category First' } },
      { id: 2, invoice_number: 654, price_with_vat: 2120.0, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03T14:00:00+00:00', client: { id: 2, name: 'Client Second' }, category: { id: 1, name: 'Category First' } }
    ]}
  end

  it 'should correctly build months range' do
    FactoryGirl.create(:invoice, issued_at: '2017-01-03 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, issued_at: '2017-04-03 14:00:00'.to_datetime)
    Invoice.months_range.should == ['2017-01-01'.to_date, '2017-02-01'.to_date, '2017-03-01'.to_date, '2017-04-01'.to_date]
  end

  it 'should correctly return summary by months for json' do
    FactoryGirl.create(:invoice, price: 1000.0, vat_rate: 5.0, issued_at: '2017-01-03 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime)
    FactoryGirl.create(:invoice, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime)
    Invoice.summary_by_months.should ==
      { summary: [
        { date: '2017-01-01', price_with_vat: 2216.0, price: 2100.0 },
        { date: '2017-02-01', price_with_vat: 2160.0, price: 2000.0 },
        { date: '2017-03-01', price_with_vat: 0.0, price: 0.0 },
        { date: '2017-04-01', price_with_vat: 4367.0, price: 4100.0 }
      ] }
  end

  it 'should correctly return summary by categories for json' do
    cat1 = FactoryGirl.create(:category, id: 1, name: 'Category First')
    cat2 = FactoryGirl.create(:category, id: 2, name: 'Category Second')
    cat3 = FactoryGirl.create(:category, id: 3, name: 'Category Third')
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
    Invoice.summary_by_categories.should == { summary: [
      { date: '2017-01-01', category: { id: 1, name: 'Category First' }, price_with_vat: 2216.0, price: 2100.0 },
      { date: '2017-01-01', category: { id: 2, name: 'Category Second' }, price_with_vat: 1166.0, price: 1100.0 },
      { date: '2017-01-01', category: { id: 3, name: 'Category Third' }, price_with_vat: 1166.0, price: 1100.0 },
      { date: '2017-02-01', category: { id: 1, name: 'Category First' }, price_with_vat: 0.0, price: 0.0 },
      { date: '2017-02-01', category: { id: 2, name: 'Category Second' }, price_with_vat: 2160.0, price: 2000.0 },
      { date: '2017-02-01', category: { id: 3, name: 'Category Third' }, price_with_vat: 2160.0, price: 2000.0 },
      { date: '2017-03-01', category: { id: 1, name: 'Category First' }, price_with_vat: 0.0, price: 0.0 },
      { date: '2017-03-01', category: { id: 2, name: 'Category Second' }, price_with_vat: 0.0, price: 0.0 },
      { date: '2017-03-01', category: { id: 3, name: 'Category Third' }, price_with_vat: 0.0, price: 0.0 },
      { date: '2017-04-01', category: { id: 1, name: 'Category First' }, price_with_vat: 4367.0, price: 4100.0 },
      { date: '2017-04-01', category: { id: 2, name: 'Category Second' }, price_with_vat: 2120.0, price: 2000.0 },
      { date: '2017-04-01', category: { id: 3, name: 'Category Third' }, price_with_vat: 2247.0, price: 2100.0 }
    ] }
  end
end
