module DataLoader
  def self.collection_of_invoices
    Invoice.includes(:client, :category).all.map { |inv| inv.jsonize.merge({client: inv.client.jsonize}).merge({category: inv.category.jsonize}) }
  end

  #TODO mě se tak nějak moc nelíbí, psát si, i když s pomocí railsů, vlastní sql :-)
  # tak jsem trošku googlil a našel group_by, což se sem docela hodilo...
  # jedním dotazem načtu všechny Invoice a pak to už upravuju strojově bez dalších dotazů
  def self.summary_by_months
    Invoice.all.group_by { |t| t.issued_at.beginning_of_month }.map { |month|
      { date: month[0].strftime('%Y-%m-%d'), price_with_vat: Utilities.virtual_sum(month[1], :price_with_vat), price: Utilities.virtual_sum(month[1], :price) }
    }
  end

  #TODO tady k celkovému dotazu se přidá ještě jeden na názvy kategorií
  def self.summary_by_categories
    Invoice.includes(:category).all.group_by { |t| t.issued_at.beginning_of_month }.map { |month|
      month[1].group_by{ |t| t.category_id }.map { |cat|
        { date: month[0].strftime('%Y-%m-%d'), category: { id: cat[0], name: cat[1][0].category.name }, price_with_vat: Utilities.virtual_sum(cat[1], :price_with_vat), price: Utilities.virtual_sum(cat[1], :price) }
      }
    }.flatten
  end
end