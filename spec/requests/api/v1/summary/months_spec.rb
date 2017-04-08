# frozen_string_literal: true

require 'rails_helper'

describe 'API by months', type: :request do
  let!(:data) {
    create(:invoice, issued_at: '2017-01-03 13:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-01-13 13:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-02-03 14:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-02-03 14:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-04-03 14:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-04-03 14:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-04-23 14:00:00'.to_datetime)
    create(:invoice, issued_at: '2017-04-23 14:00:00'.to_datetime)
  }

  it 'should response with 200' do
    get '/api/v1/summary/months'

    expect(response).to be_success
  end

  it 'should have 4 records' do
    get '/api/v1/summary/months'

    expect(jsoned['summary'].length).to eq(4)
  end
end
