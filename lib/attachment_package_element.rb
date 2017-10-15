# frozen_string_literal: true
class AttachmentPackageElement
  def initialize(package, attachment)
    @package = package
    @attachment = attachment

    save_to_file
  end

  private

  def save_to_file
    Rails.logger.info("Adding attachment with id: #{@attachment.id} to package for translation with id: #{@package.translation.id}")

    sha_filename = save_attachment_to_file
    @package.zip_file.add(sha_filename, "#{@package.directory}/#{sha_filename}")
    @package.add_node('resource', @package.resources_node, @attachment.file.original_filename, sha_filename)
  end

  def save_attachment_to_file
    string_io_bytes = open(@attachment.file.url).read
    sha_filename = @attachment.sha256

    File.binwrite("#{@package.directory}/#{sha_filename}", string_io_bytes)
    sha_filename
  end
end
