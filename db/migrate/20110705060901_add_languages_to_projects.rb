class AddLanguagesToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :languages, :text
  end

  def self.down
    remove_column :projects, :languages
  end
end
