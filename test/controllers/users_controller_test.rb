require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { access_token: @user.access_token, activation_token: @user.activation_token, avatar_content_type: @user.avatar_content_type, avatar_file_name: @user.avatar_file_name, avatar_file_size: @user.avatar_file_size, avatar_updated_at: @user.avatar_updated_at, bio: @user.bio, display: @user.display, email: @user.email, fax: @user.fax, fb_image_url: @user.fb_image_url, first_name: @user.first_name, home_phone: @user.home_phone, is_active: @user.is_active, is_admin: @user.is_admin, last_name: @user.last_name, mobile_phone: @user.mobile_phone, oauth_expires_at: @user.oauth_expires_at, oauth_token: @user.oauth_token, password_digest: @user.password_digest, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, phone: @user.phone, position: @user.position, provider: @user.provider, session_token: @user.session_token, string: @user.string, timezone: @user.timezone, title: @user.title, uid: @user.uid, work_phone: @user.work_phone }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { access_token: @user.access_token, activation_token: @user.activation_token, avatar_content_type: @user.avatar_content_type, avatar_file_name: @user.avatar_file_name, avatar_file_size: @user.avatar_file_size, avatar_updated_at: @user.avatar_updated_at, bio: @user.bio, display: @user.display, email: @user.email, fax: @user.fax, fb_image_url: @user.fb_image_url, first_name: @user.first_name, home_phone: @user.home_phone, is_active: @user.is_active, is_admin: @user.is_admin, last_name: @user.last_name, mobile_phone: @user.mobile_phone, oauth_expires_at: @user.oauth_expires_at, oauth_token: @user.oauth_token, password_digest: @user.password_digest, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, phone: @user.phone, position: @user.position, provider: @user.provider, session_token: @user.session_token, string: @user.string, timezone: @user.timezone, title: @user.title, uid: @user.uid, work_phone: @user.work_phone }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
