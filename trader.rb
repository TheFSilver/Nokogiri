# frozen_string_literal: true

require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Boucle Bonus pour relancer le scrapping toutes les heures
loop do
  crypto_names = []
  crypto_prices = []
  crypto_array = []

  # Code qui récupère les noms de chaque crypto
  def collecting_names(c_names)
    page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
    page.css('td.no-wrap.currency-name > a').each do |name|
      c_names << name.text
    end
  end

  collecting_names(crypto_names)

  # Code qui récupère les prix de chaque crypto
  def collecting_prices(c_prices)
    page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
    page.css('td:nth-child(5) > a').each do |price|
      c_prices << price.text
    end
  end

  collecting_prices(crypto_prices)

  # Code qui affiche chaque crypto et les enregistre dans un array de hash
  x = 0
  while x < crypto_names.size
    crypto_array << { "Crypto Name" => crypto_names[x], "Price" => crypto_prices[x] }
    puts "\n**********************************************************"
    puts crypto_array[x]
    puts "**********************************************************\n"
    x += 1
  end

  # Timer de 3600 secondes >> soit une heure
  sleep 3600
end
