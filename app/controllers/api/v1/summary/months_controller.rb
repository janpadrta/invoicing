# frozen_string_literal: true

class Api::V1::Summary::MonthsController < BaseApiController
  def index
    render json: { summary: DataLoader.summary_by_months }, status: 200
  end
end
