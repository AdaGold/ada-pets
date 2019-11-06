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
      render json: { ok: false, errors: ["Not Found"] }, status: :not_found
      return
    end
  end

  # private

  #   def pet_params
  #     params.require(:pet).permit(:name, :age, :human)
  #   end
end
