module ControllerAuthorization
  extend ActiveSupport::Concern

  included do
    helper_method :admin_user?
  end

  def admin_user?
    current_user && current_user.admin?
  end

  def check_admin
    unless admin_user?
      flash[:error] = "You are not authorized to view this page."
      redirect_to root_url, status: 401
    end
  end
end
