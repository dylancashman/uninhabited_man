require 'test_helper'

class SiteIterationTest < ActiveSupport::TestCase
  before do
    @site_iteration ||= FactoryGirl.build(:site_iteration)
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

  test 'automatically sets a site iteration number on creation' do
    assert_equal nil, @site_iteration.iteration_number
    @site_iteration.save
    assert_equal 1, @site_iteration.iteration_number

    #knockdown
    @site_iteration.destroy!
  end

  test 'automatically sets the next site iteration number on creation' do
    @site_iteration.save
    assert_equal 1, @site_iteration.iteration_number
    second_iteration = FactoryGirl.create(:site_iteration)
    assert_equal 2, second_iteration.iteration_number

    #knockdown
    @site_iteration.destroy!
    second_iteration.destroy!
  end

end
