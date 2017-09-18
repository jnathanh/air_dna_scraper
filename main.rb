require 'active_support/all'
require 'pry'
require 'rest_client'
require 'uri'
require 'net/http'
# require 'wombat'
require 'selenium-webdriver'


load 'air_dna_city_scraper.rb'
load 'air_dna_city.rb'
load 'city_sdk.rb'
load 'data.rb'

wa = Washington.new
cities = wa.cities_in(county_name: :king)  + wa.cities_in(county_name: :snohomish) + wa.cities_in(county_name: :pierce)

# cities = [
# 'Algona',
# 'Aukeen',
# 'Black Diamond',
# 'Burien',
# 'Carnation',
# 'Clyde Hill',
# 'Des Moines',
# 'Duvall',
# 'Hunts Point',
# 'Lake Forest Park',
# 'Maple Valley',
# 'Normandy Park',
# 'Pacific',
# 'SeaTac',
# 'Shoreline',
# 'Snoqualmie',
# 'Tukwila',
# 'Vashon Island',
# 'Woodinville',
# 'Yarrow Point',
# 'Brier',
# 'Cascade',
# 'Darrington',
# 'Granite Falls',
# 'Lake Stevens',
# 'Mill Creek',
# 'Mountlake Terrace',
# 'Sultan',
# 'Tulalip',
# 'Woodway',
# 'Buckley',
# 'Carbonado',
# 'DuPont',
# 'Eatonville',
# 'Edgewood',
# 'Fife',
# 'Fircrest',
# 'Milton',
# 'Orting',
# 'Roy',
# 'Ruston',
# 'South Prairie',
# 'Steilacoom',
# 'Sumner',
# 'Wilkeson',
# ]

scraper = AirDnaCityScraper.new

city_data = []

begin
cities.each do |city_name|
  city_data << scraper.scrape(city_name)
end
rescue Exception, SystemExit, Interrupt => e
binding.pry
end

rows = []
city_data.reject!(&:blank?)

all_headers = city_data.map(&:keys).flatten.uniq

city_data.each do |city|
  values = all_headers.map{|x| city[x]}
  rows << CSV::Row.new(all_headers,values)
end

table = CSV::Table.new(rows)

File.write('air_dna_city_data.csv',table.to_s)

