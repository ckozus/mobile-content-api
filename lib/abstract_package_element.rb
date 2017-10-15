# frozen_string_literal: true

require 'abstraction'

class AbstractPackageElement
  abstract

  def initialize(package, element)
    @element = element
    @package = package

    add_to_package
  end

  def add_to_package
    log
    save_to_file
    @package.zip_file.add(@sha_filename, "#{@package.directory}/#{@sha_filename}")
    add_to_manifest
  end

  private

  def log
    Rails.logger.info(message)
  end

  def message; end

  def save_to_file; end

  def add_to_manifest; end
end
