# frozen_string_literal: true

module Operator
  module Managed
    class EnableModel < Patterns::Service
      def initialize(model)
        self.model = model
      end

      def call
        model.include Annotations::ModelExtensions::Annotated
      end

      private

      attr_accessor :model
    end
  end
end
