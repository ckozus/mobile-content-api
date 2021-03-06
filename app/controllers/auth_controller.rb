# frozen_string_literal: true

class AuthController < ApplicationController
  def create
    code = AccessCode.find_by(code: data_attrs[:code])

    return render_bad_request("Access code not found.") if code.nil?
    return render_bad_request("Access code expired.") if expired(code)
    render json: AuthToken.create!(access_code: code), status: :created
  end

  private

  def expired(code)
    code.expiration < DateTime.now.utc
  end

  def render_bad_request(message)
    code = AccessCode.new
    code.errors.add(:code, message)

    render_error(code, :bad_request)
  end
end
