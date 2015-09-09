class DocumentsController < ApplicationController

	require 'Jive'

	def index
		@client = Client.find_by(token: params[:token])
		@docs = Document.where(client: @client)
	end

	def show
		@client = Client.find_by(token: params[:token])
		@doc = Document.find_by(id: params[:id], client: @client)
	end

	def upload
		@client = Client.find_by(token: params[:token])
	end

	def process_upload		
		@client = Client.find_by(token: params[:token].downcase.strip)		
		jive = Jive.new('social')
		@errors, @created = [], []
		if @client
			contents = File.open(params[:file].path, 'r+').read
			new_file = File.new(params[:file].path, 'w+')
			new_file.write(contents.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
			new_file.read
			CSV.foreach(new_file.path, headers: true) do |row|
				if row[0]
					resp = jive.get_doc(row[0])
					if resp and resp["list"]
						html = jive.get_doc_html(resp)
						doc = Document.new(title: resp["list"][0]["subject"], body: html, link: row[0].strip, client: client)
						if doc.save 
							doc.save
							@created.push resp["list"][0]["subject"]
						else
							if doc.errors.full_messages[0] == "Title has already been taken" and doc.errors.full_messages.size == 1
								@errors.push "#{resp["list"][0]["subject"]} already exists"
							else
								@errors.push(doc.errors.full_messages)
							end
						end
					else
						@errors.push "#{row[0]} -- #{resp}"
					end
				end
			end
		else
			@errors.push "Client #{params[:token]} not found."
		end
		@error_count = @errors.size
		@created_count = @created.size
	end

	def api_get_documents
		client = Client.find_by(token: params[:token])
		if client
			respond({ status: 200, docs: Document.where(client: client) })
		else
			respond({ status: 400, error: "Client not found." })
		end
	end

end
