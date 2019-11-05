class PetsController < ApplicationController
  def index
    # @pets = Pet.all
    render json: { ready_for_lunch: "yassss" }, status: :ok
  end



  private

    def pet_params
      params.require(:pet).permit(:name, :age, :human)
    end
end
