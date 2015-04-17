class Post < ActiveRecord::Base
  has_many :post_tags
  has_many :tags,
            through: :post_tags
  belongs_to :site_iteration
  before_save :attach_current_iteration

  has_attached_file :title_image, :styles => { :medium => "300x300>", :thumb => "100x100>", :square => "200x200#" }, :default_url => "/images/:style/missing.png"
  validates_attachment :title_image,  content_type: { content_type: /\Aimage\/.*\Z/ }
  
  # give better urls like posts/my-interesting-post instead of posts/12
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def post_date_string
    created_at.strftime("%D")
  end

  def to_s
    title
  end

  private
  def attach_current_iteration
    self.site_iteration ||= SiteIteration.current_site_iteration
  end
end
