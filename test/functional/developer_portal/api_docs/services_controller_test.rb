require 'test_helper'

class DeveloperPortal::ApiDocs::ServicesControllerTest < DeveloperPortal::ActionController::TestCase

  def setup
    provider = FactoryBot.create(:simple_provider)
    buyer    = FactoryBot.create(:simple_buyer, provider_account: provider)

    host! provider.internal_domain

    login_as buyer.first_admin
  end

  def test_index
    get :index, format: :json

    assert_equal 200, response.status
  end
end
