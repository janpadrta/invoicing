require 'rails_helper'

describe ImportClientService do
  context 'client without error' do
    let!(:line) { {'client name': 'Bruce Wayne', 'client company number': 112233}}

    it 'should correctly import client' do
      expect(ImportClientService.new.call(line).errors.present?).to be_truthy
    end
  end

  context 'client with error' do
    let!(:line) { {'client name': '', 'client company number': 112233}}

    it 'should not be valid' do
      expect(ImportClientService.new.call(line).errors.present?).to be_truthy
    end
  end
end