require 'test_helper'

PET_FIELDS = ["age", "human", "id", "name"]

describe PetsController do
  describe "index" do
    it "responds with JSON and success" do
      get pets_path

      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end

    it "responds with the expected list of pets" do
      get pets_path

      names = Pet.columns.map do |c| 
        c.name
      end

      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array
      expect(body.size).must_equal Pet.count
      body.each do |pet_hash| 
        expect(pet_hash).must_be_instance_of Hash
        expect(pet_hash.keys.sort).must_equal names.sort
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
    it "retrieves one pet" do
      # Arrange
      pet = Pet.first

      # Act
      get pet_path(pet)
      body = JSON.parse(response.body)

      # Assert
      must_respond_with :success
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal PET_FIELDS
    end

    it "sends back not found if the pet does not exist" do
      # Act
      get pet_path(-1)
      body = JSON.parse(response.body)

      # Assert
      must_respond_with :not_found
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Hash
      expect(body.keys).must_include "errors"
    end
  end
end
