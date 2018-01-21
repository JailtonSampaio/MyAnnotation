class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.date :date
      t.string :title
      t.text :content
      t.references :user, index: true, foreign_key: true
      t.integer :status

      t.timestamps null: false
    end
  end
end
