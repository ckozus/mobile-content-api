# frozen_string_literal: true
require 'rails_helper'
require 'abstract_package_element'

describe AbstractPackageElement do
  let(:element) { double }
  let(:package) { double }

  before do
    allow(package).to receive(:directory)
  end

  context 'initialize' do
    before do
      allow(package).to receive(:zip_file).and_return(double.as_null_object)
    end

    it 'sets element' do
      result = TestPackageElement.new(package, element)

      expect(result.element).to be(element)
    end

    it 'sets package' do
      result = TestPackageElement.new(package, element)

      expect(result.package).to be(package)
    end
  end

  context 'add to package' do
    let(:zip_file) do
      d = double
      allow(d).to receive(:add)
      d
    end
    let(:directory) { 'test' }
    let(:package_element) { TestPackageElement.new(package, element) }

    before do
      allow(package).to receive(:zip_file).and_return(zip_file)
      allow(package).to receive(:directory).and_return(directory)

      allow(package_element).to receive(:save_to_file)
      allow(package_element).to receive(:add_to_manifest)
    end

    it 'adds to zip file' do
      sha = '123456789'
      package_element.sha_filename = sha

      package_element.add_to_package

      expect(zip_file).to have_received(:add).with(sha, "#{directory}/#{sha}")
    end

    it 'saves to file, then adds to zip' do
      package_element.add_to_package

      expect(package_element).to have_received(:save_to_file).ordered
      expect(package.zip_file).to have_received(:add).ordered
    end

    it 'then adds to zip, then adds to manifest' do
      package_element.add_to_package

      expect(package.zip_file).to have_received(:add).ordered
      expect(package_element).to have_received(:add_to_manifest).ordered
    end
  end

  private

  class TestPackageElement < AbstractPackageElement
    attr_reader :element, :package
    attr_writer :sha_filename
  end
end
