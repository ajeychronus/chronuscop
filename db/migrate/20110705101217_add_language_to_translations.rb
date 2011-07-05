class AddLanguageToTranslations < ActiveRecord::Migration
  def self.up
    add_column :translations, :language, :integer
  end

  def self.down
    remove_column :translations, :language
  end
end
