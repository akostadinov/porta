# frozen_string_literal: true

module Annotations
  module ModelExtensions
    module Annotated
      extend ActiveSupport::Concern

      included do
        has_many :annotation_references, as: :annotated, dependent: :destroy
        # noinspection RailsParamDefResolve
        has_many :annotations, through: :annotation_references, as: :annotated
      end
    end
  end
end
