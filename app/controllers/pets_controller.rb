class PetsController < ApplicationController
  def index
    pets = Pet.all
    render json: pets, status: :ok
  end

  def show
    pet = Pet.find_by(id: params[:id])

    if pet
      render json: pet.as_json(only: [:id, :name, :age, :human])
      return
    else
      # head :not_found
      render json: { errors: ["Not Found"] }, status: :not_found
      return
    end
  end

  def create
    new_pet = Pet.new(pet_params)
    if new_pet.save
      render json: new_pet.as_json(only: [:id]), status: :created
    else
      # Do something else
    end
  end

  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end
end
