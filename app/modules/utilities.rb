module Utilities
  def self.months_range(klass, column)
    date_from  = klass.minimum(column).to_date
    date_to    = klass.maximum(column).to_date
    date_range = date_from..date_to

    date_range.map { |d| Date.new(d.year, d.month, 1) }.uniq
  end

  def self.virtual_sum(collection, v_attr) # Totals the virtual attributes of a collection
    collection.sum { |collect| collect.method(v_attr).call }.to_f
  end
end