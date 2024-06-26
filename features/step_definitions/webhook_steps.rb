# frozen_string_literal: true

Given "{provider} has all webhooks enabled" do |provider|
  attrs = %w[account_created_on
             account_updated_on
             account_deleted_on
             account_plan_changed_on
             user_created_on
             user_updated_on
             user_deleted_on
             application_created_on
             application_updated_on
             application_deleted_on
             application_plan_changed_on
             application_user_key_updated_on
             application_key_created_on
             application_key_deleted_on
             application_suspended_on].index_with { |key| true }

  hook = provider.build_web_hook(attrs.merge(active: true,
                                             provider_actions: true,
                                             url: 'http://localhost/'))
  hook.save!
end

Given "{provider} has a webhook with endpoint {string}" do |provider, url|
  attrs = {
    active: true,
    provider_actions: true,
    url: url
  }

  (provider.web_hook || provider.build_web_hook).update!(attrs)
end

Then /^there should be no webhooks enqueued$/ do
  assert_equal 0, Sidekiq::Queue.new('web_hooks').size
end
