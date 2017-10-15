# frozen_string_literal: true

require 'zip'
require 'page_client'
require 'xml_util'
require 'attachment_package_element'
require 'page_package_element'

class Package
  attr_reader :directory, :document, :zip_file, :translation, :resources_node, :pages_node

  def self.s3_object(translation)
    s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    bucket = s3.bucket(ENV['MOBILE_CONTENT_API_BUCKET'])
    bucket.object(translation.object_name.to_s)
  end

  def initialize(translation)
    @translation = translation

    @directory = "pages/#{SecureRandom.uuid}"
    FileUtils.mkdir_p(@directory)
  end

  def push_to_s3
    Rails.logger.info "Starting build of translation with id: #{@translation.id}"

    build_zip
    upload

    PageClient.delete_temp_dir(@directory)
  rescue StandardError => e
    PageClient.delete_temp_dir(@directory)
    raise e
  end

  def add_node(type, parent, filename, sha_filename)
    node = Nokogiri::XML::Node.new(type, @document)
    node['filename'] = filename
    node['src'] = sha_filename
    parent.add_child(node)
  end

  private

  def build_zip
    @document = Nokogiri::XML(@translation.resource.manifest)
    manifest_node = load_or_create_manifest_node

    @pages_node = Nokogiri::XML::Node.new('pages', @document)
    @resources_node = Nokogiri::XML::Node.new('resources', @document)

    manifest_node.add_child(@pages_node)
    manifest_node.add_child(@resources_node)

    Zip::File.open("#{@directory}/#{@translation.zip_name}", Zip::File::CREATE) do |zip_file|
      @zip_file = zip_file

      add_content

      manifest_filename = write_manifest_to_file
      zip_file.add(manifest_filename, "#{@directory}/#{manifest_filename}")
    end
  end

  def add_content
    @translation.resource.pages.order(position: :asc).each { |page| PagePackageElement.new(self, page) }
    @translation.resource.attachments.where(is_zipped: true).each { |a| AttachmentPackageElement.new(self, a) }
  end

  def load_or_create_manifest_node
    return load_manifest if @translation.resource.manifest.present?

    manifest = Nokogiri::XML::Node.new('manifest', @document)
    @document.root = manifest
    manifest
  end

  def load_manifest
    manifest_node = XmlUtil.xpath_namespace(@document, 'manifest').first
    insert_translated_name(manifest_node)
    manifest_node
  end

  def insert_translated_name(manifest_node)
    title_node = XmlUtil.xpath_namespace(manifest_node, 'title').first
    return if title_node.nil?

    name_node = title_node.xpath('content:text[@i18n-id]').first
    name_node.content = @translation.translated_name
  end

  def write_manifest_to_file
    filename = XmlUtil.xml_filename_sha(@document.to_s)
    @translation.manifest_name = filename

    file = File.open("#{@directory}/#{filename}", 'w')
    @document.write_to(file)
    file.close

    filename
  end

  def upload
    Rails.logger.info("Uploading zip to OneSky for translation with id: #{@translation.id}")

    obj = self.class.s3_object(@translation)
    obj.upload_file("#{@directory}/#{@translation.zip_name}", acl: 'public-read')
  end
end
