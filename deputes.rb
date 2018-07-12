require 'rubygems'
require 'nokogiri'
require 'open-uri'

deputees_name = []
deputees_firstname = []
deputees_lastname = []
deputees_link = []
deputees_email = []
deputees_array = []

puts "\nVeuillez patienter pendant que nous traitons votre demande.\n"

# Code pour récupérer les noms de chaque député
def deputee_names(full_name)
  page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
  page.css('#deputes-list > div > ul > li > a').each do |name|
    if name.text.include?('M. ')
      full_name << name.text[3..-1]
    elsif name.text.include?('Mme ')
      full_name << name.text[4..-1]
    end
  end
end

deputee_names(deputees_name)

# Code pour séparer les prénoms et noms de chaque député dans des arrays différentes
deputees_name.each do |names|
  name = names.split(" ").to_a
  deputees_firstname << name[0]
  deputees_lastname << name.drop(1).join(" ")
end

# Code pour récupérer les liens de page de chaque député
def deputees_pages(links)
  page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
  page.css('#deputes-list > div > ul > li > a').each do |link|
    web = "http://www2.assemblee-nationale.fr"
    web << link['href']
    links << web
  end
end

deputees_pages(deputees_link)
puts "Cette opération peut prendre quelques minutes selon la configuration de votre matériel..."

# Code pour récupérer l'adresse mail d'un député
def deputees_mails(emails_array, url_array)
  page = Nokogiri::HTML(open(url_array))
  page.css('#haut-contenu-page > article > div.contenu-principal.en-direct-commission.clearfix > div > dl > dd:nth-child(8) > ul > li:nth-child(1) > a').each do |email|
    if email['href'][7..-1].include?('@')
      emails_array << email['href'][7..-1]
    else
      emails_array << "no email found"
    end
  end
end

# Boucle pour appliquer la récupération d'adresse mail à chaque député
deputees_link.each do |deputee_link|
  deputees_mails(deputees_email, deputee_link)
end

# Code pour enregistrer les données scrappées dans une array de hashes
x = 0
while x < deputees_name.size
  deputees_array << { "prenom" => deputees_firstname[x], "nom" => deputees_lastname[x], "email" => deputees_email[x] }
    puts "\n*************************************************************************************"
    puts deputees_array[x]
    puts "*************************************************************************************\n"
  x += 1
end
