# frozen_string_literal: true

class Api::V1::Summary::CategoriesController < BaseApiController
  def index
    render json: { summary: DataLoader.summary_by_categories }, status: 200
  end
end
