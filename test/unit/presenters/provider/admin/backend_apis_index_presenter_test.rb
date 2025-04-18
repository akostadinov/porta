# frozen_string_literal: true

require 'test_helper'

class Provider::Admin::BackendApisIndexPresenterTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  def setup
    @provider = FactoryBot.create(:simple_provider)
    @user = FactoryBot.create(:admin, account: provider)
  end

  attr_reader :provider, :user

  test "20 backend apis per page by default" do
    FactoryBot.create_list(:backend_api, 30, account: provider)
    presenter = Provider::Admin::BackendApisIndexPresenter.new(user: user, params: {})

    assert_equal 20, presenter.backend_apis.size
  end

  test "deleted backend apis should not be shown" do
    FactoryBot.create(:backend_api, account: provider)
    presenter = Provider::Admin::BackendApisIndexPresenter.new(user: user, params: {})
    backend_api = provider.backend_apis.first

    assert_includes provider.backend_apis, backend_api
    assert_includes presenter.backend_apis, backend_api

    backend_api.mark_as_deleted

    presenter = Provider::Admin::BackendApisIndexPresenter.new(user: user, params: {})

    assert_includes provider.backend_apis, backend_api
    assert_not_includes presenter.backend_apis, backend_api
  end

  test "filter backend_apis by query" do
    ThinkingSphinx::Test.rt_run do
      perform_enqueued_jobs(only: SphinxIndexationWorker) do
        FactoryBot.create(:backend_api, name: 'Pepe API', account: provider)
        FactoryBot.create(:backend_api, name: 'Pepa API', account: provider)
      end

      assert_equal 2, Provider::Admin::BackendApisIndexPresenter.new(user: user, params: { search: {} }).backend_apis.size
      assert_equal 2, Provider::Admin::BackendApisIndexPresenter.new(user: user, params: { search: { query: 'api' } }).backend_apis.size
      assert_equal 1, Provider::Admin::BackendApisIndexPresenter.new(user: user, params: { search: { query: 'pepe' } }).backend_apis.size
      assert_equal 0, Provider::Admin::BackendApisIndexPresenter.new(user: user, params: { search: { query: 'asdf' } }).backend_apis.size
    end
  end

  test "paginate backend_apis" do
    FactoryBot.create_list(:backend_api, 10, account: provider)
    presenter = Provider::Admin::BackendApisIndexPresenter.new(user: user, params: { page: 1, per_page: 5 })
    assert_equal 5, presenter.backend_apis.size
  end

  test '#data includes the data for the index page' do
    presenter = Provider::Admin::BackendApisIndexPresenter.new(user: user, params: {})

    data = presenter.data
    assert data.key? :'new-backend-path'
    assert data.key? :backends
    assert data.key? :'backends-count'
  end
end
