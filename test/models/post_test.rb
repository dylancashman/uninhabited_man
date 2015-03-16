require 'test_helper'

class PostTest < ActiveSupport::TestCase
  before do
    @post ||= FactoryGirl.build(:post)
  end

  test 'is valid' do
    assert_equal true, @post.valid?
  end

  test 'has nil site iteration' do
    assert_equal nil, @post.site_iteration
  end

  test 'has many tags' do
    assert_equal [], @post.tags
  end

  test 'sets site_iteration after creation' do
    # setup
    site_iteration = FactoryGirl.create(:site_iteration)
    @post.save!

    assert_equal site_iteration, @post.site_iteration

    # knockdown
    site_iteration.destroy!
    @post.destroy!
  end
end
