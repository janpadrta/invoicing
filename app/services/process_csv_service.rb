class ProcessCsvService
  def work(file)
    errors_arr = []
    CSV.foreach(file.path, headers: true) do |row|
      ret = ImportInvoiceService.new.call(row.to_hash)
      errors_arr << ret unless ret.blank?
    end
    errors_arr
  end
end
