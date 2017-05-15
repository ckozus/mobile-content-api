# frozen_string_literal: true

require 'rails_helper'

describe TranslationElement do
  it 'sets OneSky phrase ID for the first translation element in a page' do
    page = Page.create!(filename: 'test.xml', resource_id: 1, structure: '<root/>')

    element = described_class.create!(page: page, text: 'test')

    expect(element.onesky_phrase_id).not_to be_nil
  end
end
