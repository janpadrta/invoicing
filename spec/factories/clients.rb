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

FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "client name #{n}" }
    company_number 123_456_789
  end
end
