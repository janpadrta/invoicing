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
  let(:invoice) { create(:invoice, price: 1000.0, vat_rate: 11.0) }
  # let(:full_invoice) { create(:invoice, number: 321, price: 1000.0, vat_rate: 5.0, issued_at: '2017-04-03 13:00:00'.to_datetime) }

  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:vat_rate) }
  it { is_expected.to validate_presence_of(:issued_at) }
  it { is_expected.to validate_numericality_of(:number) }
  it { is_expected.to validate_numericality_of(:price) }
  it { is_expected.to validate_numericality_of(:vat_rate) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:category) }

  it 'should show vat rate multiplier' do
    expect(invoice.multiplier_vat_rate).to eq(1.11)
  end

  it 'should show price with vat' do
    expect(invoice.price_with_vat).to eq(1110.0)
  end

  it 'jsonize should have correct keys' do
    expect(invoice.jsonize.keys).to include(:id, :invoice_number, :price_with_vat, :price, :vat_rate, :issued_at)
  end
end
