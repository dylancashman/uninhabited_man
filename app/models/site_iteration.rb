class SiteIteration < ActiveRecord::Base
  has_many :posts
  has_attached_file :screenshot, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :screenshot, presence: true, # weird paperclip syntax
                                    content_type: { content_type: /\Aimage\/.*\Z/ }
end
