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

When /^(?:|I |they )press( invisible)? "([^"]*)"(?: within "([^"]*)")?$/ do |invisible, button, selector|
  with_scope(selector) do
    click_button(button, visible: !invisible)
  end
end

When /^(?:|I |they |the buyer )follow( invisible)? "([^"]*)"(?: within "([^"]*)")?$/ do |invisible, link, selector|
  with_scope(selector) do
    click_link(link, exact: true, visible: !invisible)
  end
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"(?: within "([^"]*)")?$/ do |path, field, selector|
  with_scope(selector) do
    attach_file(field, File.join(Rails.root,path))
  end
end

Then /^(?:|I |they )should see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_content(regex)
    else
      assert page.has_content?(regex)
    end
  end
end

# Then /^(?:|I )should see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
#   regexp = Regexp.new(regexp, Regexp::IGNORECASE)
#   with_scope(selector) do
#     if page.respond_to? :should
#       page.should have_xpath('//*', :text => regexp)
#     else
#       assert page.has_xpath?('//*', :text => regexp)
#     end
#   end
# end

Then /^(?:|I |they )should not see "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  regex = Regexp.new(Regexp.escape(text), Regexp::IGNORECASE)
  with_scope(selector) do
    refute_text :visible, regex
  end
end

Then /^(?:|I )should not see \/([^\/]*)\/(?: within "([^"]*)")?$/ do |regexp, selector|
  regexp = Regexp.new(regexp, Regexp::IGNORECASE)
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_xpath('//*', :text => regexp)
    else
      assert page.has_no_xpath?('//*', :text => regexp)
    end
  end
end

Then /^the "([^"]*)" field(?: within "([^"]*)")? should contain "([^"]*)"$/ do |field, selector, value|
  with_scope(selector) do
    field = find_field(field)
    field_value = field['value'] || field.native.attribute('value').to_s
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    expect(field_checked).to be_truthy
  end
end

Then /^the "([^"]*)" checkbox(?: within "([^"]*)")? should not be checked$/ do |label, selector|
  with_scope(selector) do
    field_checked = find_field(label)['checked']
    expect(field_checked).to be_falsy
  end
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
