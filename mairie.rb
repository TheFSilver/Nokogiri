require 'rubygems'
require 'nokogiri'
require 'open-uri'

city_names = []
city_urls = []
city_emails = []
city_array = []

# Code qui récupère toutes les url de villes du Val d'Oise.
def get_all_the_urls_of_val_doise_townhalls(urls_array)
  page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  page.css('.lientxt').each do |url|
    web = "http://annuaire-des-mairies.com"
    web << url['href'][1..-1]
    urls_array << web
  end
end

get_all_the_urls_of_val_doise_townhalls(city_urls)

# Code qui récupère tous les noms de villes du Val d'Oise.
def get_the_name_of_a_townhal_from_its_webpage(city)
  page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
  page.css('.lientxt').each do |name|
    city << name.text
  end
end

get_the_name_of_a_townhal_from_its_webpage(city_names)

# Code qui récupère l'adresse email à partir de l'url d'une mairie
def get_the_email_of_a_townhal_from_its_webpage(emails_array, url_array)
  doc = Nokogiri::HTML(open(url_array))
  doc.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |email|
    emails_array << email.text
  end
end

# Boucle qui récupère toutes les adresses email des mairies du Val d'Oise
city_urls.each do |city_url|
  get_the_email_of_a_townhal_from_its_webpage(city_emails, city_url)
end

# Boucle Bonus qui enregistre les données scrappées dans un array d'hash et l'affiche
x = 0
while x < city_names.size
  city_array << { "name" => city_names[x], "email" => city_emails[x], "lien" => city_urls[x] }
  puts "\n**************************************************************************************************************************************************************"
  puts city_array[x]
  puts "**************************************************************************************************************************************************************\n"
  x += 1
end
