require 'test_helper'

class PetsControllerTest < ActionDispatch::IntegrationTest
  describe "index" do
    # These tests are a little verbose - yours do not need to be
    # this explicit.
    it "is a real working route" do
      get pets_url
      must_respond_with :success
    end

    it "returns json" do
      get pets_url
      response.header['Content-Type'].must_include 'json'
    end

    it "returns an Array" do
      get pets_url

      body = JSON.parse(response.body)
      body.must_be_kind_of Array
    end

    it "returns all of the pets" do
      get pets_url

      body = JSON.parse(response.body)
      body.length.must_equal Pet.count
    end

    it "returns pets with exactly the required fields" do
      keys = %w(age human id name)
      get pets_url
      body = JSON.parse(response.body)
      body.each do |pet|
        pet.keys.sort.must_equal keys
      end
    end
  end

  describe "show" do
    # This bit is up to you!
    it "can get a pet" do
      get pet_path(pets(:two).id)
      must_respond_with :success
    end
  end

  it "returns a 404 for pets that are not found" do
    pet = pets(:two)
    pet.destroy
    get pet_path(pet.id)

    must_respond_with :not_found
  end

  describe "create" do
    let(:pet_data) {
      {
        name: "Jack",
        age: 7,
        human: "Captain Barbossa"
      }
    }

    it "Creates a new pet" do
      proc {
        post pets_path, params: {pet: pet_data}
      }.must_change "Pet.count", 1

      must_respond_with :success
    end

    it "Returns a bad for an invalid pet" do
      pet_data.delete(:name)
      proc {
        post pets_path, params: {pet: pet_data}
      }.wont_change "Pet.count", 0

      must_respond_with :bad_request
      body = JSON.parse(response.body)
      body.must_be_kind_of Hash
      body.must_include "ok"
      body["ok"].must_equal false
      body.must_include "errors"
      body["errors"].must_include "name"
    end
  end
end
