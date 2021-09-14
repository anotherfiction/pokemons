require 'rails_helper'

describe PokemonsController do
  describe 'GET index' do
    let(:pokemons) { { a: 'b' } }

    before do
      pokemon_association = instance_double 'Pokemon::ActiveRecord_Relation', map: pokemons
      Pokemon.stub includes: pokemon_association
    end

    it 'renders pokemons' do
      get :index

      response.body.should eq('{"a":"b"}')
    end
  end

  describe 'GET show' do
    let(:pokemon) { instance_double Pokemon, to_json: { a: 'b' } }

    before do
      Pokemon.stub find: pokemon
    end

    it 'finds the pokemon' do
      Pokemon.should_receive(:find).with '1'

      get :show, params: { id: 1 }
    end

    it 'renders the pokemon' do
      get :show, params: { id: 1 }

      response.body.should eq('{"a":"b"}')
    end
  end
end
