# config/routes.rb
Rails.application.routes.draw do
  root to: 'cryptos#index'
  get '/cryptos', to: 'cryptos#index', as: 'cryptos'
  get '/cryptos/:id', to: 'cryptos#details', as: 'crypto_details'
  # other routes...
end
