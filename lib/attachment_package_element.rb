# frozen_string_literal: true

require 'abstract_package_element'

class AttachmentPackageElement < AbstractPackageElement
  def message
    "Adding attachment with id: #{@element.id} to package for translation with id: #{@package.translation.id}"
  end

  def save_to_file
    string_io_bytes = open(@element.file.url).read
    @sha_filename = @element.sha256

    File.binwrite("#{@package.directory}/#{@sha_filename}", string_io_bytes)
  end

  def add_to_manifest
    @package.add_node('resource', @package.resources_node, @element.file.original_filename, @sha_filename)
  end
end
