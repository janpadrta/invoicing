require 'rails_helper'

describe DataLoader do
  context 'Collection' do
    let!(:invoices) { create_list(:invoice, 3) }

    it 'should correctly return collection for json' do
      expect(DataLoader.collection_of_invoices.first.keys).to include(:id, :invoice_number, :price_with_vat, :price, :vat_rate, :issued_at, :client, :category)
    end
  end

  context 'By months' do
    let!(:invoice_1) { create(:invoice, price: 1000.0, vat_rate: 5.0, issued_at: '2017-01-03 13:00:00'.to_datetime) }
    let!(:invoice_2) { create(:invoice, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime) }
    let!(:invoice_3) { create(:invoice, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime) }
    let!(:invoice_4) { create(:invoice, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime) }
    let!(:invoice_5) { create(:invoice, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime) }

    it 'should correctly return summary by months for json' do
      expect(DataLoader.summary_by_months.first.keys).to include(:date, :price_with_vat, :price)
    end

    it 'should return correct number of records' do
      expect(DataLoader.summary_by_months.length).to eq(3)
    end

    #TODO toto tu mám pro kontrolu, že to všechno mám úplně správně
    it 'should correctly return summary by months for json' do
      DataLoader.summary_by_months.should ==
          [
              { date: '2017-01-01', price_with_vat: 2216.0, price: 2100.0 },
              { date: '2017-02-01', price_with_vat: 2160.0, price: 2000.0 },
              { date: '2017-04-01', price_with_vat: 4367.0, price: 4100.0 }
          ]
    end
  end

  context 'By category' do
    let(:cat1) { create(:category, name: 'Category First') }
    let(:cat2) { create(:category, name: 'Category Second') }
    let(:cat3) { create(:category, name: 'Category Third') }
    let!(:invoice1) { create(:invoice, category_id: cat1.id, price: 1000.0, vat_rate: 5.0, issued_at: '2017-01-03 13:00:00'.to_datetime) }
    let!(:invoice2) { create(:invoice, category_id: cat2.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime) }
    let!(:invoice3) { create(:invoice, category_id: cat3.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime) }
    let!(:invoice4) { create(:invoice, category_id: cat1.id, price: 1100.0, vat_rate: 6.0, issued_at: '2017-01-13 13:00:00'.to_datetime) }
    let!(:invoice5) { create(:invoice, category_id: cat2.id, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime) }
    let!(:invoice6) { create(:invoice, category_id: cat3.id, price: 2000.0, vat_rate: 8.0, issued_at: '2017-02-03 14:00:00'.to_datetime) }
    let!(:invoice7) { create(:invoice, category_id: cat1.id, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime) }
    let!(:invoice8) { create(:invoice, category_id: cat2.id, price: 2000.0, vat_rate: 6.0, issued_at: '2017-04-03 14:00:00'.to_datetime) }
    let!(:invoice9) { create(:invoice, category_id: cat3.id, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime) }
    let!(:invoice10) { create(:invoice, category_id: cat1.id, price: 2100.0, vat_rate: 7.0, issued_at: '2017-04-23 14:00:00'.to_datetime) }

    it 'should correctly return summary by categories for json' do
      expect(DataLoader.summary_by_categories.first.keys).to include(:date, :category, :price_with_vat, :price)
    end

    it 'should return correct number of records' do
      expect(DataLoader.summary_by_categories.length).to eq(8)
    end

    #TODO toto tu mám pro kontrolu, že to všechno mám úplně správně
    it 'should correctly return summary by categories for json' do
      DataLoader.summary_by_categories.should == [
          { date: '2017-01-01', category: { id: cat1.id, name: 'Category First' }, price_with_vat: 2216.0, price: 2100.0 },
          { date: '2017-01-01', category: { id: cat2.id, name: 'Category Second' }, price_with_vat: 1166.0, price: 1100.0 },
          { date: '2017-01-01', category: { id: cat3.id, name: 'Category Third' }, price_with_vat: 1166.0, price: 1100.0 },
          { date: '2017-02-01', category: { id: cat2.id, name: 'Category Second' }, price_with_vat: 2160.0, price: 2000.0 },
          { date: '2017-02-01', category: { id: cat3.id, name: 'Category Third' }, price_with_vat: 2160.0, price: 2000.0 },
          { date: '2017-04-01', category: { id: cat1.id, name: 'Category First' }, price_with_vat: 4367.0, price: 4100.0 },
          { date: '2017-04-01', category: { id: cat2.id, name: 'Category Second' }, price_with_vat: 2120.0, price: 2000.0 },
          { date: '2017-04-01', category: { id: cat3.id, name: 'Category Third' }, price_with_vat: 2247.0, price: 2100.0 }
      ]
    end
  end
end
