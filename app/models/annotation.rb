class Annotation < ApplicationRecord
  has_many :annotation_references, dependent: :destroy
  has_many :annotated, through: :annotation_references
end
