class AddSlugToSurveys < ActiveRecord::Migration[7.0]

  def change
    add_column :survey_surveys, :slug, :string

    add_index :survey_surveys, :slug, unique: true
  end
end
