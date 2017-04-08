# frozen_string_literal: true

class Api::V1::InvoicesController < BaseApiController
  def index
    render json: Invoice.collection, status: 200
  end
end
