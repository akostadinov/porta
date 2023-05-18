class AnnotationReference < ApplicationRecord
  belongs_to :annotated, polymorphic: true
  belongs_to :annotation
end
