require 'test_helper'

class SiteIterationTest < ActiveSupport::TestCase
  before do
    @site_iteration ||= SiteIteration.new(screenshot_file_name: 'foo',
                                          screenshot_content_type: 'image/jpeg',
                                          screenshot_file_size: 100)
  end

  test 'is valid' do
    assert_equal true, @site_iteration.valid?
  end

  test 'has many posts' do
    assert_equal [], @site_iteration.posts
  end

  test 'requires screenshot' do
    @site_iteration.screenshot = nil
    assert_equal false, @site_iteration.valid?
  end

  test 'requires screenshot to be of image format' do
    @site_iteration.screenshot_content_type = 'text/plain'
    assert_equal false, @site_iteration.valid?
  end

end
