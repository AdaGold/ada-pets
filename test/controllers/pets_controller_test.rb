require 'test_helper'

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
end
