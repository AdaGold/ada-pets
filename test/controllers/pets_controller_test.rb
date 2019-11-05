require 'test_helper'

describe PetsController do
  describe "index" do
    it "responds with JSON and success" do
      get pets_path
      
      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :success
      
    end
    
    it "responds with an array of pet hashes" do
      get pets_path

      # Get the body of the response
      body = JSON.parse(response.body)

      
      # Assert
      expect(body).must_be_instance_of Array
      body.each do |pet|
        expect(pet).must_be_instance_of Hash
        expect(pet.keys.sort).must_equal ["age", "human", "id", "name"]
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
end
