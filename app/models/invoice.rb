# frozen_string_literal: true

# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  client_id   :integer
#  category_id :integer
#  number      :integer
#  price       :decimal(, )
#  vat_rate    :decimal(, )
#  issued_at   :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Invoice < ApplicationRecord
  include ActiveModel::AttributeAssignment

  belongs_to :client
  belongs_to :category

  validates_presence_of :number, :price, :vat_rate, :issued_at
  validates_numericality_of :number, :price, :vat_rate

  def self.process(file)
    CSV.foreach(file.path, headers: true) do |row|
      Invoice.import(row.to_hash)
    end
  end

  def self.import(par)
    cli = Client.find_or_create_by(name: par['client name'], company_number: par['client company number'])
    return 'Wrong client parameters.' unless cli.id.present?
    cat = Category.find_or_create_by(name: par['category name'])
    return 'Wrong category parameters.' unless cat.id.present?

    inv = Invoice.create(
      client_id: cli.id,
      category_id: cat.id,
      number: par['invoice number'],
      price: par['invoice price'],
      vat_rate: par['invoice vat rate'],
      issued_at: par['invoice issued at'].to_datetime
    )
    return 'Wrong Invoice parameters.' unless inv.id.present?
    true
  end

  def price_with_vat
    (price * multiplier_vat_rate).round(2)
  end

  def multiplier_vat_rate
    1 + vat_rate / 100.0
  end

  def self.collection
    ret = []
    Invoice.includes(:client, :category).all.each do |inv|
      line = {}
      line[:id] = inv.id
      line[:invoice_number] = inv.number
      line[:price_with_vat] = inv.price_with_vat
      line[:price] = inv.price
      line[:vat_rate] = inv.vat_rate
      line[:issued_at] = inv.issued_at.strftime('%FT%T%:z')
      line[:client] = { id: inv.client.id, name: inv.client.name }
      line[:category] = { id: inv.category.id, name: inv.category.name }
      ret << line
    end
    ret
  end

  def self.months_range
    date_from  = Invoice.minimum(:issued_at).to_date
    date_to    = Invoice.maximum(:issued_at).to_date
    date_range = date_from..date_to

    date_range.map { |d| Date.new(d.year, d.month, 1) }.uniq
  end

  def self.month_data(month)
    ret = { date: month.strftime('%Y-%m-%d'), price_with_vat: 0.0, price: 0.0 }
    Invoice.where(issued_at: month.beginning_of_month..month.end_of_month).each do |inv|
      ret[:price_with_vat] += inv.price_with_vat
      ret[:price] += inv.price
    end
    ret
  end

  def self.summary_by_months
    ret = []
    dates = Invoice.months_range
    dates.each do |dat|
      ret << Invoice.month_data(dat)
    end
    { summary: ret }
  end

  def self.month_data_categories(month)
    ret = []
    Category.all.each do |cat|
      line = { date: month.strftime('%Y-%m-%d'), category: { id: cat.id, name: cat.name }, price_with_vat: 0.0, price: 0.0 }
      cat.invoices.where(issued_at: month.beginning_of_month..month.end_of_month).each do |inv|
        line[:price_with_vat] += inv.price_with_vat
        line[:price] += inv.price
      end
      ret << line
    end
    ret
  end

  def self.summary_by_categories
    ret = { summary: [] }
    dates = Invoice.months_range
    dates.each do |dat|
      ret[:summary] += Invoice.month_data_categories(dat)
    end
    ret
  end
end
