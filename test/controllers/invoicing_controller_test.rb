# frozen_string_literal: true

require 'test_helper'

class InvoicingControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get invoicing_home_url
    assert_response :success
  end

  test 'should get upload' do
    get invoicing_upload_url
    assert_response :success
  end
end
