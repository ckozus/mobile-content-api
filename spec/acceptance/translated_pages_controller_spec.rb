# frozen_string_literal: true

require 'acceptance_helper'

resource 'TranslatedPages' do
  let(:authorization) { AuthToken.create!(access_code: AccessCode.find(1)).token }
  let(:data) do
    { data: { type: :translated_page,
              attributes: { value: 'This is a translated page.', page_id: 3, translation_id: 1 } } }
  end

  before do
    header 'Authorization', :authorization
  end

  post 'translated_pages/' do
    requires_authorization

    it 'create an Translated Page' do
      do_request data

      expect(status).to be(201)
      expect(response_body).not_to be_nil
    end

    it 'sets location header', document: false do
      do_request data

      expect(response_headers['Location']).to match(%r{translated_pages\/\d+})
    end
  end

  put 'translated_pages/:id' do
    let(:id) { 1 }

    requires_authorization

    it 'update an Translated Pages' do
      do_request data

      expect(status).to be(201)
      expect(response_body).not_to be_nil
    end
  end

  delete 'translated_pages/:id' do
    let(:id) { 1 }

    requires_authorization

    it 'delete an Translated Page' do
      do_request

      expect(status).to be(204)
      expect(response_body).to be_empty
    end
  end
end