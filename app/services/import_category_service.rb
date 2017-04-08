class ImportCategoryService
  def call(line)
    Category.find_or_create_by(name: line['category name'])
  end
end
