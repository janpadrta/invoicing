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

FactoryGirl.define do
  factory :invoice do
    client
    category
    number 123_456_789
    price 10.0
    vat_rate 21.0
    issued_at Time.now
  end
end
