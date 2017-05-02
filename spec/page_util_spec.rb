# frozen_string_literal: true

require 'rails_helper'
require 'page_util'

describe PageUtil do
  it 'deletes all temp files after successful request' do
    allow(RestClient).to receive(:post)

    push

    pages_dir = Dir.glob('pages/*')
    expect(pages_dir).to be_empty
  end

  it 'deletes all temp files if error is raised' do
    allow(RestClient).to receive(:post).and_raise(StandardError)

    expect { push }.to raise_error(StandardError)

    pages_dir = Dir.glob('pages/*')
    expect(pages_dir).to be_empty
  end

  it 'posts to OneSky' do
    expect(RestClient).to receive(:post).with('https://platform.api.onesky.io/1/projects/1/files', anything)

    push
  end

  private def push
    elements = [2]
    elements[0] = TranslationElement.new(id: 1, text: 'phrase 1')
    elements[1] = TranslationElement.new(id: 2, text: 'phrase 2')

    page = Page.new(filename: 'test_page.xml', translation_elements: elements)

    resource = Resource.new(pages: [page], onesky_project_id: 1)

    page_util = PageUtil.new(resource, 'de')
    page_util.push_new_onesky_translation
  end
end