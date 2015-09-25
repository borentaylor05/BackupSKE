require "Jive"

task get_docs: :environment do 
	jive = Jive.new('social')
	resp = jive.get_doc("DOC-410051")
	html = jive.get_doc_html(resp)
	doc = Document.new(title: resp["list"][0]["subject"], body: html)
	doc.save
end

task get_test_docs: :environment do 
	jive = Jive.new('social')
	docs = jive.grab("/contents?filter=type(document)")
	docs["list"].each do |doc|		
		puts doc["resources"]["html"]["ref"]
	end
end

task parse_link: :environment do 
	jive = Jive.new('social')
	puts jive.parse_link("https://social.teletech.com/docs/DOC-414110")
end

task remove_docs: :environment do 
	Document.destroy_all
end

task jive_test_connection: :environment do 
	jive = Jive.new('social')
	puts jive.grab('/people/98086')
end