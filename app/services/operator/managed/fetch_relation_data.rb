# frozen_string_literal: true

module Operator
  module Managed
    class FetchRelationData < Patterns::Service
      def initialize(active_record_relation)
        self.active_record_relation = active_record_relation
      end

      def call
        active_record_relation.includes(:annotation_references)
      end

      private

      attr_accessor :active_record_relation
    end
  end
end
