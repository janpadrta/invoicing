# frozen_string_literal: true

class Api::V1::InvoicesController < BaseApiController
  def collection
    render json: Invoice.collection, status: 200
  end

  def summary_by_months
    render json: Invoice.summary_by_months, status: 200
  end

  def summary_by_categories
    render json: Invoice.summary_by_categories, status: 200
  end
end
