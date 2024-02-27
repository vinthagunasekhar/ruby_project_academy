class CryptosController < ApplicationController
  include HTTParty

  BASE_URL = "https://pro-api.coinmarketcap.com/v1/cryptocurrency"
  API_KEY = "82e88177-ea2a-48d4-8ca0-0326f0b62f22"

  def index
    @cryptos = params[:filter].present? ? filter_cryptos(params[:filter]) : fetch_top_cryptos
  end

  def details
    @crypto = fetch_crypto_details(params[:id])
  end

  private

  def fetch_top_cryptos
    url = "#{BASE_URL}/listings/latest?CMC_PRO_API_KEY=#{API_KEY}&start=1&limit=10&convert=USD"
    response = HTTParty.get(url, headers: headers)
    format_cryptos(response.parsed_response["data"])
  end

  def filter_cryptos(filter)
    fetch_top_cryptos.select { |crypto| crypto[:name].downcase.include?(filter.downcase) }
  end

  def fetch_crypto_details(crypto_id)
    url = "#{BASE_URL}/info?id=#{crypto_id}&CMC_PRO_API_KEY=#{API_KEY}"
    response = HTTParty.get(url, headers: headers)
    crypto_data = response.parsed_response["data"][crypto_id]
    format_crypto_details(crypto_data) if crypto_data
  end

  def format_cryptos(cryptos)
    cryptos.map do |crypto|
      {
        id: crypto["id"],
        name: crypto["name"],
        image_url: "https://s2.coinmarketcap.com/static/img/coins/64x64/#{crypto['id']}.png",
        launch_date: crypto["date_added"],
        description: "Description for #{crypto['name']}",
        price_change_24h: crypto.dig("quote", "USD", "percent_change_24h") || 0,
        current_price: crypto.dig("quote", "USD", "price") || 0
      }
    end
  end

  def format_crypto_details(crypto)
    {
      id: crypto["id"],
      name: crypto["name"],
      description: crypto["description"],
      image_url: "https://s2.coinmarketcap.com/static/img/coins/64x64/#{crypto['id']}.png"
    }
  end

  def headers
    { "X-CMC_PRO_API_KEY" => API_KEY }
  end
end
