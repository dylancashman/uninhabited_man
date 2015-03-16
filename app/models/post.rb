class Post < ActiveRecord::Base
  has_many :post_tags
  has_many :tags,
            through: :post_tags
  belongs_to :site_iteration
  before_save :attach_current_iteration

  private
  def attach_current_iteration
    self.site_iteration ||= SiteIteration.current_site_iteration
  end
end
