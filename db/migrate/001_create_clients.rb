# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :company_number, limit: 8

      t.timestamps
    end
  end
end
