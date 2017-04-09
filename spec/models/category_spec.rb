# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe Category do
  let(:category) { create(:category) }

  it { is_expected.to validate_presence_of(:name) }

  it { is_expected.to have_many(:invoices) }

  it 'jsonize should have correct keys' do
    expect(category.jsonize.keys).to include(:id, :name)
  end
end
