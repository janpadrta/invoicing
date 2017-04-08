class ImportClientService
  def call(line)
    p 'XXXXX' + line.to_s
    Client.find_or_create_by(name: line['client name'], company_number: line['client company number'])
  end
end
