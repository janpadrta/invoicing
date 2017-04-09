# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id             :integer          not null, primary key
#  name           :string
#  company_number :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Client < ApplicationRecord
  has_many :invoices

  validates_presence_of :name, :company_number
  validates_numericality_of :company_number

  def jsonize
    { id: id, name: name }
  end
end
