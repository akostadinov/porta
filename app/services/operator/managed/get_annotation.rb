# frozen_string_literal: true

module Operator
  module Managed
    class GetAnnotation < Patterns::Service
      class << self
        attr_accessor :annotation
        private :annotation, :annotation=
      end

      def call
        annotation = self.class.send :annotation

        return annotation if annotation

        self.class.send :annotation=, Annotation.where(annotation: ANNOTATION, tenant_id: nil).take
      end
    end
  end
end
