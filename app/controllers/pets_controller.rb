KEYS = [:id, :name, :age, :human]

class PetsController < ApplicationController
  def index
    pets = Pet.all.as_json(only: KEYS)
    render json: pets, status: :ok
  end

  def show
    pet_id = params[:id]
    pet = Pet.find_by(id: pet_id)
    if pet
      render json: pet.as_json(only: KEYS) #status: :ok
      return
    else
      render json: pet, status: :not_found
      #render json: {"errors"=>["not found"]}, status: :not_found
      return
    end
  end



  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end
end
