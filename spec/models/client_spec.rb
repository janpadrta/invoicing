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

require 'spec_helper'

describe 'My behaviour' do
  it 'should do something' do
    Client.new.valid?.should be_falsey
    Client.new(name: 'aaa').valid?.should be_falsey
    Client.new(company_number: 123_456).valid?.should be_falsey
    Client.new(name: 'aaa', company_number: 123_456).valid?.should be_truthy
    Client.new(name: 'aaa', company_number: 'bbb').valid?.should be_falsey
  end
end
