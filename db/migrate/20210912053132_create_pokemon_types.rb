class CreatePokemonTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :pokemon_types do |t|
      t.references :pokemon
      t.references :type
      t.integer :slot

      t.timestamps
    end
  end
end
