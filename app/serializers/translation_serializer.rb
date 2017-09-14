# frozen_string_literal: true

class TranslationSerializer < ActiveModel::Serializer
  type 'translation'
  attributes :id, :status, :version, :manifest_name, :translated_name, :translated_description

  belongs_to :resource
  belongs_to :language
end
