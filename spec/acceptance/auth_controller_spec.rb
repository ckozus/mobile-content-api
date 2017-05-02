# frozen_string_literal: true

require 'acceptance_helper'

resource 'Auth' do
  header 'Accept', 'application/vnd.api+json'
  header 'Content-Type', 'application/vnd.api+json'
  let(:raw_post) { params.to_json }

  post 'auth/' do
    it 'create a token with valid code' do
      do_request data: { type: :auth_token, attributes: { code: 123_456 } }

      expect(status).to be(201)
    end

    it 'create a token with invalid code' do
      do_request data: { type: :auth_token, attributes: { code: 999_999 } }

      expect(status).to be(400)
    end
  end
end