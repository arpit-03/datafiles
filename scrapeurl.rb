require 'httparty'
require 'nokogiri'
require 'csv'
class Scrapeurl

def begina(i,b)

	

	

sleep(rand(2..6))
url="https://www.shiksha.com/architecture-planning/colleges/colleges-india-#{i}"
@parse_page ||= Nokogiri::HTML(HTTParty.get(url))
p=@parse_page.css('.elipsysBox').css('h2')

p.each do |k|
	if(k.at_css('a').attributes['href']!=nil)
puts k.at_css('a').attributes['href'].text
b.push(k.at_css('a').attributes['href'].text)
end
end
puts b.length

end
end

class Start

def bh
i=1
b=[];
while i<=29
	s=Scrapeurl.new
	s.begina(i,b)
bc(b)
i=i+1
end

end

def bc(b)

	CSV.open("architecture.csv", "w") do |csv|
		b.each do |d|
		csv << [d.to_s]
	end
end
	end

end