require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "sign in redirects to lenses and sign out redirects to root" do
    get signin_path
    assert_response :success

    sign_in_as users(:ian)
    assert_redirected_to lenses_url

    delete session_path
    assert_redirected_to root_url
  end

  test "invalid credentials re-render the sign in form" do
    post session_path, params: { username: "ian", password: "wrong" }
    assert_response :unprocessable_entity
    assert_match "Invalid email/password combination!", response.body
  end
end
