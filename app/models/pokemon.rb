class Pokemon < ApplicationRecord
  has_many :pokemon_types, dependent: :destroy
  has_many :types, through: :pokemon_types

  def to_json(*_args)
    {
      id: id,
      name: name,
      types: pokemon_types.map do |pokemon_type|
        {
          slot: pokemon_type.slot,
          name: pokemon_type.type.name
        }
      end
    }
  end
end
