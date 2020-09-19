require 'httparty'
require 'nokogiri'
require 'csv'
require 'down'
require 'fileutils'

class Run
def sets

a=CSV.read('./design.csv')
i=0
while i<a.length
s=Savecollege.new

s.set("https://www.shiksha.com"+a[i][0].to_s)
puts i.to_s+" design"
i=i+1
end
end
end



class Savecollege
	
def set(url)
@parse_page ||= Nokogiri::HTML(HTTParty.get(url))

k = @parse_page.at_css('.header-bgcol')
cover_img=""
if(k!=nil)
k=k.attributes['style'].text.to_s
cover_img=k[22..k.length-3]
end

if(cover_img.to_s=="https://images.shiksha.ws/public/images/instHeaderDesktop.jpg" || cover_img=="")
cover_img=""
end

 icon= @parse_page.css('.header_img').at_css('img')
  if(icon!=nil)
icon=icon.attributes['src'].text
else
	icon=""
 end

title= @parse_page.css('.clg_dtlswidget').css('.inst-name')

if(title.children[0]!=nil)
title=title.children[0].text
location= @parse_page.css('.ilp-loc').children[2]
if(location!=nil)
location=location.text.strip
end
facts= @parse_page.css('.facts-widget').css('.clg-tip').children
if (facts == nil || facts == [])
facts =[]
end

table= @parse_page.css('.facts_table').css('tbody').css('tr')
fact=[]
i=0
if(table!=nil)
	while(i<table.length)
fact[fact.length]=table[i].css('td')[0].text,table[i].css('td')[1].text.strip
i=i+1
	end
else
	table=[]
end
	

facility =[]
j=0
fac= @parse_page.css('.infraDataList').css('.wrapFlx').css('.icn')
if(fac!=nil)
while (j<fac.length)
facility[facility.length]=fac[j].children[1].text
j=j+1
	end
end

k=0
degrees=[]
degreesname=[]
collegename=[]
factname=[]
@parse_page1 ||= Nokogiri::HTML(HTTParty.get(url+"/courses"))
m= @parse_page1.css('.bubble-list')[0]
if(m==nil)
m=@parse_page1.css('.bubble-list')
end
m=m.css('li')
while (k<m.length)
if(m[k].text!="")
degrees[degrees.length]=m[k].at_css('a').attributes['href']
degreesname[degreesname.length]=m[k].text
end
k=k+1
end

k=0
coursesname=[]
fullcoursedata=[]
while(k<degrees.length)
s1=Savecourse.new

 coursesname[coursesname.length]=s1.savec(degrees[k],collegename,factname)
n=0
while n<collegename.length
fullcoursedata[fullcoursedata.length]=degreesname[k],collegename[n],factname[n]
n=n+1
end
collegename=[]
factname=[]
k=k+1
end

fullcollegedata = [cover_img,icon,title,location,facts,fact,facility,fullcoursedata]


if(cover_img!="")
tempfile = Down.download(cover_img)
FileUtils.mv(tempfile.path, "./designcolgdata/#{title}-cover")
end
if (icon!="")
tempfile2 = Down.download(icon)
FileUtils.mv(tempfile2.path, "./designcolgdata/#{title}-icon")
end
CSV.open("designcolgfulldata.csv", "a+") do |csv|
		csv << fullcollegedata
end
puts fullcollegedata
end
end
end

class Savecourse
def savec(url,pagename,facts)
@parse_page2 ||= Nokogiri::HTML(HTTParty.get("https://www.shiksha.com"+url))
pageurl=[]
i=0
k= @parse_page2.css('.ctp-SrpDiv')

while i<k.length
pageurl[pageurl.length]=k[i].at_css('.clp-anchor').attributes['href']
k2= k[i].css('.ctp-detail').css('li')
l=0
if(k2.css('.view_rvws')!=nil)
l=2
end
while l<k2.length
facts[facts.length]=k2[l].text
l=l+2
end
i=i+1
end


j=0
while j<pageurl.length
	o= @parse_page2.css('.ctp-SrpDiv').css('.clp-anchor')[j].text
	
	if(o[o.length-3,o.length]=="...")

m=Savename.new
if(pageurl[j]!=nil)
kl=m.saven("https://www.shiksha.com"+pageurl[j])
end
if(kl!=nil || kl!="")
pagename[pagename.length]=kl
end
else
	pagename[pagename.length]=o
end

j=j+1
end

end
end

class Savename
def saven(url)
@parse_page3 ||= Nokogiri::HTML(HTTParty.get(url))
k= @parse_page3.css('.inst-name')
if(k.children[0]!=nil)
return k.children[0].text
else
return k.children.text
end
end

end