# frozen_string_literal: true

require 'rails_helper'
require 'attachment_package_element'

describe AttachmentPackageElement do
  let(:translation) { instance_double(Translation) }
  let(:resources_node) { instance_double }
  let(:package) do
    p = instance_double
    allow(p).to receive(:translation).and_return(translation)
    allow(p).to receive(:resources_node).and_return(resources_node)
    p
  end

  let(:original_filename) { instance_double }
  let(:file) do
    f = instance_double
    allow(f).to receive(:original_filename).and_return(original_filename)
    f
  end
  let(:element) do
    e = instance_double
    allow(e).to receive(:file).and_return(file)
    e
  end

  context 'save to file' do
  end

  context 'add to manifest node' do
    it "with name 'resource'" do
      package_element = described_class.new(package, element)

      package_element.add_to_manifest
    end
  end
end
