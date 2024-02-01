# frozen_string_literal: true

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'uri'
require 'cgi'

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I |they )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I |they )press( invisible)? "([^"]*)"$/ do |invisible, button|
  click_button(button, visible: !invisible)
end

When /^(?:|I |they |the buyer )follow( any)?( invisible)? "([^"]*)"$/ do |any, invisible, link|
  # there must be a capybara bug because assert_link fails with
  # Unused parameters passed to Capybara::Queries::SelectorQuery : [:link, "..."]
  # assert_link(link, exact: true, visible: !invisible, count: 1) unless any
  assert_selector(:link, link, exact: true, visible: !invisible, count: 1) unless any
  click_link(link, exact: true, visible: !invisible)
end

Then /^(?:|I |they )should see "([^"]*)"$/ do |text|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  if page.respond_to? :should
    page.should have_content(regex)
  else
    assert page.has_content?(regex)
  end
end

Then "the page should contain {string}" do |text|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  if page.respond_to? :should
    page.should have_content(regex)
  else
    assert page.has_content?(regex)
  end
end

# Check whether a specific selector from features/support/selectors.rb is currently visible
# on the page.
#
#   And they should be able to see the products widget
#   And they should not be able to see the feature "Max. Speed"
#
Then "they {should} be able to see {css_selector}" do |visible, selector|
  assert_equal visible, has_selector?(:css, selector, wait: 0)
end

Then /^(?:|I |they )should not see "([^"]*)"$/ do |text|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  refute_text :visible, regex
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp, Regexp::IGNORECASE)
  if page.respond_to? :should
    page.should have_no_xpath('//*', :text => regexp)
  else
    assert page.has_no_xpath?('//*', :text => regexp)
  end
end

Then /^the "([^"]*)" field should contain "([^"]*)"$/ do |field, value|
  field = find_field(field)
  field_value = field['value'] || field.native.attribute('value').to_s
  if field_value.respond_to? :should
    field_value.should =~ /#{value}/
  else
    assert_match(/#{value}/, field_value)
  end
end

Then /^the "([^"]*)" checkbox should be checked$/ do |label|
  field_checked = find_field(label)['checked']
  expect(field_checked).to be_truthy
end

Then /^the "([^"]*)" checkbox should not be checked$/ do |label|
  field_checked = find_field(label)['checked']
  expect(field_checked).to be_falsy
end

Then "the current page is {}" do |page_name|
  assert_current_path path_to(page_name)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  if current_path.respond_to? :should
    current_path.should == path_to(page_name)
  else
    assert_equal path_to(page_name), current_path
  end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair {|k,v| expected_params[k] = v.split(',')}

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Given "tab {string} is selected" do |tab|
  find('.pf-c-tabs .pf-c-tabs__item button', text: tab).click
end

When 'I change to tab {string}' do |tab|
  find('.pf-c-tabs .pf-c-tabs__item button', text: tab).click
end

And "confirm the dialog" do
  accept_confirm
end

Then /^(.+) and confirm the dialog(?: "(.*)")?$/ do |original, text|
  ActiveSupport::Deprecation.warn "🥒 Replace with step 'And confirm the dialog'"
  if rack_test?
    step original
  else
    accept_confirm(text) do
      step original
    end
    wait_for_requests
  end
end

Then "(they )should see the following details(:)" do |table|
  assert table.rows_hash.all? do |key, value|
    find('dl dt', text: key).has_sibling?('dd', text: value)
  end
end

Then "(I )(they )should see the flash message {string}" do |message|
  assert_flash(message)
end
