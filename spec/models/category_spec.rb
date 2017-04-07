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
  # let(:category) { described_class.new }

  it { is_expected.to validate_presence_of(:name) }

  # it 'should do something' do
  #   described_class.new.valid?.should be_falsey
  #   described_class.new(name: 'aaa').valid?.should be_truthy
  # end
end
