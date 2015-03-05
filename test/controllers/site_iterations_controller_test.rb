class SiteIterationsControllerTest < ActionController::TestCase
  before do
    @site_iteration = SiteIteration.create(screenshot_file_name: 'foo',
                                          screenshot_content_type: 'image/jpeg',
                                          screenshot_file_size: 100)
  end

  #interesting that a pattern like this, without factories or whatever, is like having a
  # constructor and a destructor!  Maintaining a clean test database is like preventing memory
  # leaks.
  after do
    @site_iteration.destroy
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:site_iterations)
  end

  test "should only allow admins to new edit create update delete" do
    get :new
    assert_response 401

    post :create
    assert_response 401

    get :edit, id: @site_iteration.id
    assert_response 401

    put :update, id: @site_iteration.id
    assert_response 401

    delete :destroy, id: @site_iteration.id
    assert_response 401
  end

  test 'should allow non-admins to view posts' do
    get :show, id: @site_iteration.id
    assert_response :success
    assert_equal assigns(:site_iteration), @site_iteration
  end
end
