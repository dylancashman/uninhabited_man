module ApplicationHelper
  def admin_user?
    current_user && current_user.admin?
  end
end
