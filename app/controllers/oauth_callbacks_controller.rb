class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :sign_in_with_oauth, only: %i[github facebook]

  def github
  end

  def facebook
  end

  private

  def sign_in_with_oauth
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: action_name.to_s) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
