# frozen_string_literal: true

module Operator
  module Managed
    class CreateAnnotation < Patterns::Service
      def call
        Annotation.create!(annotation: ANNOTATION, value: ANNOTATION_VALUE, tenant_id: nil)
      end
    end
  end
end
