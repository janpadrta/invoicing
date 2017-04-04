# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :invoices do |t|
      t.references(:client, index: true)
      t.references(:category, index: true)
      t.integer :number, limit: 8
      t.decimal :price
      t.decimal :vat_rate
      t.datetime :issued_at

      t.timestamps
    end
  end
end
