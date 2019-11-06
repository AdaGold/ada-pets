require 'test_helper'
PET_KEYS = ["id", "name", "age", "human"]

describe PetsController do
  describe "index" do

    it "responds with JSON, success, and an array of pet hashes" do
      get pets_path
      
      body = check_response(expected_type: Array) 
    
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal PET_KEYS.sort
      end
    end

    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all
  
      # Act
      get pets_path
      body = JSON.parse(response.body)
  
      # Assert
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
    end
  end

  describe "show" do
    it "retrieves a pet" do
      pet = pets(:one)

      get pet_path(pet)
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      must_respond_with :success #:ok
      #expect(body.keys.sort).must_equal ["age", "human", "id", "name"]
      expect(body["name"]).must_equal "Peanut"
    end

    it "returns a not found error and status for an invalid pet" do
      invalid_id = -100

      get pet_path(invalid_id)
      body = JSON.parse(response.body)

      expect(body).must_be_instance_of Hash
      expect(body["errors"]).must_equal ["not found"]
      must_respond_with :not_found
    end

  end

  describe "create" do
    let(:pet_data) {
      {
        pet: {
          age: 13,
          name: 'Stinker',
          human: 'Grace'
        }
      }
    }
    it "can create a new pet" do
      expect {
        post pets_path, params: pet_data
      }.must_differ 'Pet.count', 1

      must_respond_with :created
    end

    it "will respond with bad_request for invalid data" do
      # Arrange - using let from above
      pet_data[:pet][:age] = nil

      expect {
        # Act
        post pets_path, params: pet_data

      # Assert
      }.wont_change "Pet.count"

      must_respond_with :bad_request

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body["errors"].keys).must_include "age"
    end

  end
end
