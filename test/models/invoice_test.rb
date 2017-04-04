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

require 'test_helper'

class InvoiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
