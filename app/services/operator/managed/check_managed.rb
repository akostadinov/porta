# frozen_string_literal: true

module Operator
  module Managed
    class CheckManaged < Patterns::Service
      def initialize(instance)
        self.instance = instance
      end

      def call
        !!instance.annotation_references.find { |ar| ar.annotation_id == GetAnnotation.call.result.id }
      end

      private

      attr_accessor :object
    end
  end
end
