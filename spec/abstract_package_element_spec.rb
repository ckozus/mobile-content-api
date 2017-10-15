# frozen_string_literal: true
require 'rails_helper'
require 'abstract_package_element'

describe AbstractPackageElement do
  context 'initialize' do
    let(:element) { double }
    let(:package) { double }

    before do
      allow(package).to receive(:zip_file).and_return(double.as_null_object)
      allow(package).to receive(:directory)

      @result = TestPackageElement.new(package, element)
    end

    it 'sets element' do
      expect(@result.element).to be(element)
    end

    it 'sets package' do
      expect(@result.package).to be(package)
    end
  end

  private

  class TestPackageElement < AbstractPackageElement
    attr_reader :element, :package
  end
end
