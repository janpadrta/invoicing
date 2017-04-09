# frozen_string_literal: true

class Api::V1::InvoicesController < BaseApiController
  def index
    render json: { invoices: DataLoader.collection_of_invoices }, status: 200
  end
end
