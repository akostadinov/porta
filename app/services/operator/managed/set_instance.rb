# frozen_string_literal: true

module Operator
  module Managed
    class SetInstance < Patterns::Service
      def initialize(instance)
        @instance = instance
      end

      def call
        annotation = GetAnnotation.call.result

        instance.annotations << annotation unless instance.annotations.include(annotation)
        instance.save
      end

      private

      attr_reader :instance
    end
  end
end
