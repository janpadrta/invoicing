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

require 'spec_helper'

describe 'My behaviour' do
  it 'should do something' do
    Category.new.valid?.should be_falsey
    Category.new(name: 'aaa').valid?.should be_truthy
  end
end
