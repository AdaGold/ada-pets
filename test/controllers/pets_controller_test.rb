require 'test_helper'

class PetsControllerTest < ActionController::TestCase

  # Necessary setup to allow ensure we support the API JSON type
  setup do
     @request.headers['Accept'] = Mime::JSON
     @request.headers['Content-Type'] = Mime::JSON.to_s
   end

  test "can get #index" do
    get :index
    assert_response :success
  end

  test "#index returns json" do
    get :index
    assert_match 'application/json', response.header['Content-Type']
  end

  test "#index returns an Array of Pet objects" do
    get :index
    # Assign the result of the response from the controller action
    body = JSON.parse(response.body)
    assert_instance_of Array, body
  end

  test "returns three pet objects" do
    get :index
    body = JSON.parse(response.body)
    assert_equal 3, body.length
  end

  test "each pet object contains the relevant keys" do
    keys = %w( age human id name ).to_set
    get :index
    pets = JSON.parse(response.body)
    pets.each.with_index do |pet, i|
      assert_equal keys, pet.keys.to_set, "Pet ##{i} did not have exact set of keys: #{pet}"
      pet.keys.each do |key|
        assert_not_nil pet[key], "Pet ##{i} had a nil value for #{key}"
      end
    end
  end
end
