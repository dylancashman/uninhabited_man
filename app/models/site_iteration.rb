class SiteIteration < ActiveRecord::Base
  belongs_to :referential_post, class_name: 'Post'
  has_many :posts
  has_attached_file :screenshot, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :screenshot, presence: true, # weird paperclip syntax
                                    content_type: { content_type: /\Aimage\/.*\Z/ }
  before_save :set_iteration_number

  def self.current_site_iteration
    order('iteration_number DESC').first
  end

  def self.next_iteration_number
    maximum(:iteration_number).to_i + 1
  end

  private
  def set_iteration_number
    self.iteration_number ||= SiteIteration.next_iteration_number
  end
end
