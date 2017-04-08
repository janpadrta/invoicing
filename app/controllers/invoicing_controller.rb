# frozen_string_literal: true

require 'csv'

class InvoicingController < ApplicationController
  def home
    @invoices = Invoice.includes(:client, :category).all
  end

  def upload
    ret = ProcessCsvService.new.work(params[:file])
    if ret.is_a?(String)
      flash[:error] = ret
    elsif ret == true
      flash[:notice] = 'File processed.'
    end
    redirect_to invoicing_home_path
  end

  def clear
    Invoice.delete_all
    Client.delete_all
    Category.delete_all
    flash[:notice] = 'Database cleared.'
    redirect_to invoicing_home_path
  end
end
