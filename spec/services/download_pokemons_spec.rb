require 'rails_helper'

describe DownloadPokemons do
  it 'does not crash when the api returns empty results' do
    stub_request(:get, 'https://pokeapi.co/api/v2/type')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: { next: nil, results: [] }.to_json, headers: {})

    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: { next: nil, results: [] }.to_json, headers: {})

    described_class.execute

    Pokemon.count.should be_zero
    Type.count.should be_zero
  end

  it 'saves types' do
    types =
      {
        count: 4,
        next: nil,
        previous: nil,
        results: [
          { name: 'normal', url: 'https://pokeapi.co/api/v2/type/1/' },
          { name: 'fighting', url: 'https://pokeapi.co/api/v2/type/2/' },
          { name: 'flying', url: 'https://pokeapi.co/api/v2/type/3/' },
          { name: 'poison', url: 'https://pokeapi.co/api/v2/type/4/' }
        ]
      }

    stub_request(:get, 'https://pokeapi.co/api/v2/type')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: types.to_json, headers: {})

    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: { next: nil, results: [] }.to_json, headers: {})

    described_class.execute

    Type.count.should eq 4

    Type.all.map(&:name).sort.should eq %w[fighting flying normal poison]
  end

  it 'saves pokemons with types' do
    types =
      {
        count: 1,
        next: nil,
        previous: nil,
        results: [
          { name: 'lightning' }
        ]
      }

    pokemons = {
      count: 5,
      next: nil,
      previous: nil,
      results: [
        { name: 'pikachu', url: 'https://pokeapi.co/api/v2/pokemon/1/' }
      ]
    }

    pikachu = {
      name: 'pikachu',
      types: [
        { type: { name: 'lightning' }, slot: 1 }
      ]
    }

    stub_request(:get, 'https://pokeapi.co/api/v2/type')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: types.to_json, headers: {})

    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: pokemons.to_json, headers: {})

    stub_request(:get, 'https://pokeapi.co/api/v2/pokemon/1/')
      .with(
        headers: {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      )
      .to_return(status: 200, body: pikachu.to_json, headers: {})

    described_class.execute

    Type.count.should be 1
    Pokemon.count.should be 1

    pokemon = Pokemon.first

    pokemon.name.should eq 'pikachu'
    pokemon.types.size.should eq 1
    type = pokemon.pokemon_types.first

    type.slot.should eq 1
    type.type.name.should eq 'lightning'
  end
end
