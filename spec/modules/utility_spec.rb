require 'rails_helper'

describe Utilities do
  let!(:invoice_1) { create(:invoice, issued_at: '2017-01-03 13:00:00'.to_datetime) }
  let!(:invoice_2) { create(:invoice, issued_at: '2017-04-03 14:00:00'.to_datetime) }

  it 'should correctly build months range' do
    expect(Utilities.months_range(Invoice, :issued_at)).to eq(%w(2017-01-01 2017-02-01 2017-03-01 2017-04-01).map(&:to_date))
  end
end