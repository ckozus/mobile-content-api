# frozen_string_literal: true

require 'rails_helper'
require 'attachment_package_element'

describe AttachmentPackageElement do
  let(:translation) { double }
  let(:resources_node) { double }
  let(:package) do
    p = double
    allow(p).to receive(:translation).and_return(translation)
    allow(p).to receive(:resources_node).and_return(resources_node)
    p
  end

  let(:original_filename) { double }
  let(:file) do
    f = double
    allow(f).to receive(:original_filename).and_return(original_filename)
    f
  end
  let(:element) do
    e = double
    allow(e).to receive(:file).and_return(file)
    e
  end

  context 'save to file' do
  end

  context 'add to manifest node' do
    it "with name 'resource'" do
      r = double

      package_element = described_class.new(package, element)

      package_element.add_to_manifest
    end
  end
end
