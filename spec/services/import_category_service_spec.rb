require 'rails_helper'

describe ImportCategoryService do
  context 'category without error' do
    let!(:line) { {'category name': 'category'} }

    it 'should correctly import category' do
      expect(ImportCategoryService.new.call(line).errors.present?).to be_truthy
    end
  end

  context 'category with error' do
    let!(:line) { {'category': ''} }

    it 'should not be valid' do
      expect(ImportCategoryService.new.call(line).errors.present?).to be_truthy
    end
  end
end