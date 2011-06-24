class CreateTranslations < ActiveRecord::Migration
  def self.up
    create_table :translations do |t|
      t.string :key
      t.text :value
      t.integer :project_id

      t.timestamps
    end
    add_index :translations, :project_id

  end

  def self.down
    drop_table :translations
  end
end
