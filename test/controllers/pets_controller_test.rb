require 'test_helper'

describe PetsController do
  PET_FIELDS = %w(id age name human).sort

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "index" do
    it "responds with JSON and success" do
      # Act
      get pets_path

      # Assert
      check_response(expected_type: Array)
    end

    it "responds with an array of pet hashes" do
      # Act
      get pets_path

      # Assert
      body = check_response(expected_type: Array)

      body.each do |pet|
        expect(pet.keys.sort).must_equal PET_FIELDS
      end
    end

    it "will respond with an empty array when there are no pets" do
      # Arrange
      Pet.destroy_all

      # Act
      get pets_path

      # Assert
      body = check_response(expected_type: Array)
      expect(body).must_equal []
    end
  end

  describe "show" do
    it "retrieves one pet" do
      # Arrange
      pet = Pet.first

      # Act
      get pet_path(pet)
      body = check_response(expected_type: Hash)

      # Assert
      expect(body.keys.sort).must_equal PET_FIELDS
    end

    it "sends back not found if the pet does not exist" do
      # Act
      get pet_path(-1)
      
      # Assert
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body.keys).must_include "errors"
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
      # Act
      expect {
        post pets_path, params: pet_data

      # Assert
      }.must_differ 'Pet.count', 1

      body = check_response(expected_type: Hash, expected_status: :created)
      new_pet = Pet.find(body["id"])
      pet_data[:pet].each do |key, value|
        expect(new_pet[key.to_s]).must_equal value
      end
    end

    it "will respond with bad_request for invalid data" do
      # Arrange
      pet_data[:pet][:age] = nil

      expect {
        # Act
        post pets_path, params: pet_data

      # Assert
      }.wont_change "Pet.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "age"
    end
  end
end
