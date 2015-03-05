require 'test_helper'

class PostTest < ActiveSupport::TestCase
  before do
    @post ||= Post.new
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
end
