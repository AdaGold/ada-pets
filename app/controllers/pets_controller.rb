KEYS = ["id", "name", "age", "human"].sort

class PetsController < ApplicationController
  def index
    pets = Pet.all.as_json(only: PET_KEYS)
    render json: pets, status: :ok
  end

  def show
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet
      render json: pet.as_json(only: PET_KEYS) #status: :ok
      return
    else
      #render json: pet, status: :not_found
      render json: {"errors"=>["not found"]}, status: :not_found
      return
    end
  end

  def create
    pet = Pet.new(pet_params)

    if pet.save
      render json: pet.as_json(only: [:id]), status: :created
      return
    else
      render json: {ok: false, errors: pet.errors.messages}, status: :bad_request
    end
  end

  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end
end
