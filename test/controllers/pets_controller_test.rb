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

  describe 'create' do

    before do
      # Create valid request
      @pet = {
        pet: {
          name: "Pie",
          human: "Clara",
          age: 1
        }
      }
    end

    it 'responds with created status when request is good' do
      # make post request to create
      # verify count +1
      expect{post pets_path, params: @pet}.must_differ 'Pet.count', 1
      # check for created code
      must_respond_with :created
      # body contains new pet's id
      body = JSON.parse(response.body)
      expect(body.keys).must_equal ['id']
      # TODO: Pet.last looks like request
    end

    it 'responds with bad_request when request has no name' do
      # make bad request
      no_name_pet = @pet
      no_name_pet[:name] = nil
      # call
      # verify count doesn't change
      expect{post pets_path, params: @pet}.wont_change 'Pet.count'
      # verify bad_request status
      must_respond_with :bad_request
      # body contains errors which contain string 'name'
      body = JSON.parse(response.body)
      expect(body['errors'].keys).must_include 'name'
    end

  end
end
