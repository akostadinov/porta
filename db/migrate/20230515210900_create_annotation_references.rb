class CreateAnnotationReferences < ActiveRecord::Migration[5.2]
  def change
    if System::Database.mysql?
      options = "CHARSET=utf8mb4 COLLATE=utf8mb4_bin"
    end

    create_table :annotations, options: options do |t|
      t.string :annotation, limit: 42, null: false
      t.string :value
      t.bigint :tenant_id

      t.timestamps
    end

    add_index :annotations, [:annotation, :tenant_id], unique: true

    reversible do |entry|
      entry.up do
        execute "INSERT INTO annotations (annotation, value) VALUES ('managed_by_operator', 'This object is managed by operator and any changes by the user might be reset')"
      end
    end

    create_table :annotation_references, options: options do |t|
      t.references :annotated, polymorphic: true, index: false, null: false
      t.bigint :tenant_id
      t.references :annotation, foreign_key: true, null: false

      t.timestamps
    end

    # this should serve as both - uniqueness constraint and for the polymorphic index
    add_index :annotation_references, [:annotated_type, :annotated_id, :annotation_id], unique: true
  end
end
