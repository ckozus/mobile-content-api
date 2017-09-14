class ChangeIsPublishedToEnum < ActiveRecord::Migration[5.0]
  class Translation < ActiveRecord::Base
  end

  def change
    add_column :translations, :status, :integer, null: false, default: 0

    Translation.where(is_published: true).each do |record|
      record.update!(status: 2)
    end

    remove_column :translations, :is_published, :boolean, null: false, default: 0
  end
end
