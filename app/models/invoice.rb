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

class Invoice < ApplicationRecord
  include ActiveModel::AttributeAssignment

  belongs_to :client
  belongs_to :category

  validates_presence_of :number, :price, :vat_rate, :issued_at
  validates_numericality_of :number, :price, :vat_rate

  def price_with_vat
    (price * multiplier_vat_rate).round(2)
  end

  def multiplier_vat_rate
    1 + vat_rate / 100.0
  end

  def jsonize
    {
        id: id,
        invoice_number: number,
        price_with_vat: price_with_vat.to_f,
        price: price.to_f,
        vat_rate: vat_rate.to_f,
        issued_at: issued_at.strftime('%FT%T%:z')
    }
  end
end
