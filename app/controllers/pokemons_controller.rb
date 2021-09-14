class PokemonsController < ApplicationController
  def index
    render json: Pokemon.includes(pokemon_types: [:type]).map(&:to_json)
  end

  def show
    pokemon = Pokemon.find params[:id]

    render json: pokemon.to_json
  end
end
