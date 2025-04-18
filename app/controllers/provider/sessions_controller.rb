# frozen_string_literal: true
class Provider::SessionsController < FrontendController
  include ThreeScale::BotProtection::Controller

  layout 'provider/login'
  skip_before_action :login_required

  before_action :ensure_provider_domain
  before_action :find_provider
  before_action :instantiate_sessions_presenter, only: [:new, :create]
  before_action :redirect_if_logged_in, only: %i[new]

  def new
    @session = Session.new
    @authentication_providers = published_authentication_providers
    @bot_protection_enabled = bot_protection_enabled?
    @qod = quote_of_day
  end

  def create
    session_return_to
    logout_keeping_session!

    @user, strategy = authenticate_user

    if @user
      self.current_user = @user
      flash[:first_login] = true if current_user.user_sessions.empty?
      create_user_session!(strategy&.authentication_provider_id)
      flash[:notice] = 'Signed in successfully'

      redirect_back_or_default provider_admin_path
    else
      new
      flash.now[:error] ||= strategy&.error_message
      attempted_cred = auth_params.fetch(:username, 'SSO')
      AuditLogService.call("Login attempt failed from #{request.remote_ip}: #{domain_account.external_admin_domain} - #{attempted_cred}. ERROR: #{strategy&.error_message}")
      render :action => :new
    end
  end

  def bounce
    auth = domain_account.self_authentication_providers.find_by!(system_name: params.require(:system_name))
    redirect_to ProviderOAuthFlowPresenter.new(auth, request, request.host).authorize_url
  end

  def destroy
    user = current_user
    logout_killing_session!
    destroy_user_session!

    if @provider.partner? && (logout_url = @provider.partner.logout_url)
      redirect_to logout_url + {user_id: user.id, provider_id: @provider.id}.to_query
    else
      redirect_to new_provider_sessions_path, notice: "You have been logged out."
    end
  end

  private

  def published_authentication_providers
    return [] unless @provider.provider_can_use?(:provider_sso)

    @provider.self_authentication_providers.published.map do |auth|
      ProviderOAuthFlowPresenter.new(auth, request, request.host)
    end
  end

  def find_provider
    @provider ||= site_account_request.find_provider
  end

  def redirect_if_logged_in
    redirect_to provider_admin_dashboard_path if logged_in?
  end

  def authenticate_user
    captcha_is_available = request.post? # Internal strategy (user & pass)
    return if captcha_is_available && !bot_check

    params = if domain_account.settings.enforce_sso?
               sso_params
             else
               request.post? ? auth_params : sso_params
    end

    # TODO: refactor the authentication flow.
    # Right now, we have a hierarchy of classes, one for each auth strategy, and we manually instance the last child
    # class, `ProviderOAuth2`, and then try all strategies one by one by calling `super` and going up in the hierarchy
    # until a strategy works. Due to this, we can't know from the here which strategy was really used.
    #
    # The hierarchy right now is:
    #
    # `ProviderOAuth2` < `OAuth2Base` < `Internal` < `SSO` < `Base`
    #
    # This is very weird because `Internal`, which means "User + pass" is not a kind of `SSO`; and `OAuth2` is not
    # a kind of `Internal`. Not to mention we are calling `SSO` to something which is merely a token authentication
    # not related at all with any SSO.
    strategy = Authentication::Strategy.build_provider(@provider)
    user = strategy.authenticate(params)

    [user, strategy]
  end

  def auth_params
    params.slice(:username, :password)
  end

  def sso_params
    params.permit(%i[token expires_at redirect_url system_name code]).merge(request: request)
  end

  def session_return_to
    return_to_params = params.permit(:return_to)[:return_to]
    if return_to_params
      return_to = safe_return_to(return_to_params)
      session[:return_to] = return_to if return_to.present?
    end
  end

  def instantiate_sessions_presenter
    @presenter = Provider::SessionsPresenter.new(domain_account)
  end

  def bot_protection_level
    domain_account.settings.admin_bot_protection_level
  end

  def quote_of_day
    return '' unless params[:qod] == 'true'

    index = rand I18n.backend.translations[:en][:qod].size

    I18n.t("qod.#{index}")
  end
end
