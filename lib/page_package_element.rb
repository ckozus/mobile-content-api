# frozen_string_literal: true

require 'abstract_package_element'

class PagePackageElement < AbstractPackageElement
  def message
    "Adding page with id: #{@element.id} to package for translation with id: #{@package.translation.id}"
  end

  def save_to_file
    translated_page = @package.translation.translated_page(@element.id, true)
    @sha_filename = XmlUtil.xml_filename_sha(translated_page)

    File.write("#{@package.directory}/#{@sha_filename}", translated_page)
  end

  def add_to_manifest
    @package.add_node('page', @package.pages_node, @element.filename, @sha_filename)
  end
end
