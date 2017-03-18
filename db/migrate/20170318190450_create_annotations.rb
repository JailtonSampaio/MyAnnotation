class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.date :date
      t.string :title
      t.text :notes
      t.references :user, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
