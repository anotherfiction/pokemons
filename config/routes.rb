Rails.application.routes.draw do
  resources :pokemons, only: %i[show index]
end
