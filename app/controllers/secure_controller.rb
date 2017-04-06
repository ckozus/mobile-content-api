# frozen_string_literal: true

class SecureController < ApplicationController
  before_action :authorize!

  private

  def authorize!
    authorization = AuthToken.find_by(token: request.headers['Authorization'])
    render json: 'Unauthorized', status: :unauthorized if authorization.nil?
  end
end