module DownloadPokemons
  extend self

  def execute
    download_types 'https://pokeapi.co/api/v2/type'
    download_pokemons 'https://pokeapi.co/api/v2/pokemon/'
  end

  private

  def download_types(url)
    response = JSON.parse(HTTParty.get(url).body)
    response['results'].each do |type|
      Type.find_or_create_by! name: type['name']
    end

    download_types(response['next']) if response['next']
  end

  def download_pokemons(url)
    response = JSON.parse(HTTParty.get(url).body)
    response['results'].each do |pokemon_json|
      pokemon = Pokemon.find_or_create_by! name: pokemon_json['name']

      pokemon_response = JSON.parse(HTTParty.get(pokemon_json['url']).body)
      pokemon_response['types'].each do |type|
        PokemonType.find_or_create_by! type: Type.find_by(name: type['type']['name']),
                                       pokemon: pokemon,
                                       slot: type['slot']
      end
    end

    download_pokemons(response['next']) if response['next']
  end
end
