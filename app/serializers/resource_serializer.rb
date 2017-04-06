# frozen_string_literal: true

class ResourceSerializer < ActiveModel::Serializer
  type 'resource'
  attributes :id, :name, :abbreviation, :onesky_project_id

  belongs_to :system

  has_many :translations
  has_many :latest_translations
  has_many :pages
end