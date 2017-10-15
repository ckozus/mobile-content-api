class PagePackageElement
  def initialize(package, page)
    @package = package
    @page = page

    save_to_file
  end

  private

  def save_to_file
    Rails.logger.info("Adding page with id: #{@page.id} to package for translation with id: #{@package.translation.id}")

    sha_filename = write_page_to_file
    @package.zip_file.add(sha_filename, "#{@package.directory}/#{sha_filename}")
    @package.add_node('page', @package.pages_node, @page.filename, sha_filename)
  end


  def write_page_to_file
    translated_page = @package.translation.translated_page(@page.id, true)
    sha_filename = XmlUtil.xml_filename_sha(translated_page)

    File.write("#{@package.directory}/#{sha_filename}", translated_page)

    sha_filename
  end
end