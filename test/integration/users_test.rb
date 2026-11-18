require "test_helper"

class UsersTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:ian)
  end

  test "index lists users" do
    get users_path
    assert_response :success
    assert_match "Ian", response.body
    assert_match "Sam", response.body
  end

  test "show renders the user profile" do
    get user_path(users(:sam))
    assert_response :success
    assert_match "Sam", response.body
    assert_match "1 sighting", response.body
  end

  test "edit renders the form for the current user" do
    get edit_user_path(users(:ian))
    assert_response :success
    assert_select "form"
  end
end
