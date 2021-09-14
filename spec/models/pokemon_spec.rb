require 'rails_helper'

describe Pokemon do
  it 'validate pokemon' do
    pokemon = build :pokemon

    pokemon.should be_valid
  end

  it 'generates JSON for a pokemon' do
    lightning_type = create :type, name: 'lightning'
    grass_type = create :type, name: 'grass'

    pokemon =
      create :pokemon,
             id: 1,
             name: 'Pikachu',
             pokemon_types: [build(:pokemon_type, type: lightning_type, slot: 1),
                             build(:pokemon_type, type: grass_type, slot: 2)]

    pokemon.to_json.should eq({ id: 1, name: 'Pikachu',
                                types: [{ name: 'lightning', slot: 1 }, { name: 'grass', slot: 2 }] })
  end
end
