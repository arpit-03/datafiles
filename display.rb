require 'csv'
csv_text = File.read('btechfulldata.csv')
csv = CSV.parse(csv_text, :headers => false)
i=1;

csv.each do |f|
if (i>=1) 
k=JSON.parse(f[7])

if(College.find_by(name: f[2],location: f[3])==nil)
College.create(name: f[2],location: f[3],facts: f[4],facts_table: f[5],facility: f[6],animation: false , humanities: false,law: false, mascom: false,medical: false, science: false, hospitality: false, architecture:false, arts: false, commerce:false,engineering: true, design:false )
k.each do |p|
if(p[2..p.length]!=nil)
Course.create(table_id: College.find_by(name: f[2],location: f[3]).id,degree: p[0], name: p[1] ,facts: p[2..p.length])
else
Course.create(table_id: College.find_by(name: f[2],location: f[3]).id,degree: p[0], name: p[1] ,facts: "")
end
end
else
us=College.find_by(name: f[2],location: f[3])
us.update(engineering:true)
end
end
i=i+1
end

k.each do |p|
puts p
end



