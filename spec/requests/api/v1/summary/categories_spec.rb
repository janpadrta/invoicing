# frozen_string_literal: true

require 'spec_helper'

describe 'API collection', type: :request do
  let(:category_1) { create(:category, name: 'Category First') }
  let(:category_2) { create(:category, name: 'Category Second') }
  let(:category_3) { create(:category, name: 'Category Third') }

  let!(:invoices) {
    create(:invoice, category_id: category_1.id, issued_at: '2017-01-03 13:00:00'.to_datetime)
    create(:invoice, category_id: category_2.id, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, category_id: category_3.id, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, category_id: category_1.id, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, category_id: category_2.id, issued_at: '2017-02-03 14:00:00'.to_datetime)
    create(:invoice, category_id: category_3.id, issued_at: '2017-02-03 14:00:00'.to_datetime)
    create(:invoice, category_id: category_1.id, issued_at: '2017-04-03 14:00:00'.to_datetime)
    create(:invoice, category_id: category_2.id, issued_at: '2017-04-03 14:00:00'.to_datetime)
    create(:invoice, category_id: category_3.id, issued_at: '2017-04-23 14:00:00'.to_datetime)
    create(:invoice, category_id: category_1.id, issued_at: '2017-04-23 14:00:00'.to_datetime)
  }

  it 'should response with 200' do
    get '/api/v1/summary/categories'

    expect(response).to be_success
  end

  it 'should have 12 results' do
    get '/api/v1/summary/categories'

    expect(jsoned['summary'].length).to eq(12)
  end
end
