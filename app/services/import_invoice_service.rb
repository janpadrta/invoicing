class ImportInvoiceService
  #TODO tady pořád nevím, jestli to nedělám moc složitě...
  def call(line)
    errors_arr = []
    cli = ImportClientService.new.call(line)
    errors_arr << cli.errors if cli.errors.present?

    cat = ImportCategoryService.new.call(line)
    errors_arr << cat.errors if cat.errors.present?

    inv = Invoice.create(
        client_id: cli.id,
        category_id: cat.id,
        number: line['invoice number'],
        price: line['invoice price'],
        vat_rate: line['invoice vat rate'],
        issued_at: line['invoice issued at'].to_datetime
    )
    errors_arr << inv.errors if inv.errors.present?
    errors_arr
  end
end
