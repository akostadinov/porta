# frozen_string_literal: true

Rails.application.config.to_prepare do
  ActiveModel::Errors.prepend ThreeScale::ErrorsToXml
end
