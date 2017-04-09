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

require 'rails_helper'

describe Client do
  let(:client) { create(:client) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:company_number) }
  it { is_expected.to validate_numericality_of(:company_number) }

  it { is_expected.to have_many(:invoices) }

  it 'jsonize should have correct keys' do
    expect(client.jsonize.keys).to include(:id, :name)
  end
end
