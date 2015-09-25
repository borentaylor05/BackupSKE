class DocumentsController < ApplicationController

	require 'Jive'

	def index
		@client = Client.find_by(token: params[:token])
		@token = @client.token
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
		@client = Client.find_by(token: params[:token].strip)		
		jive = Jive.new('social')
		@errors, @created = [], []
		if @client
			# copy contents into new file and encode new file w/ UTF-8
			contents = File.open(params[:file].path, 'r+').read
			new_file = File.new(params[:file].path, 'w+')
			new_file.write(contents.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: ''))
			new_file.read
			# End Encoding
			# 
			# Begin reading CSV
			CSV.foreach(new_file.path, headers: true) do |row|
				if row[0]
					# get Jive document via API
					resp = jive.get_doc(row[0])
					if resp and resp["list"]
						# Gets document HTML from Jive API response
						html = jive.get_doc_html(resp)
						# Creates doc in our database
						doc = Document.new(title: resp["list"][0]["subject"], body: html, link: row[0].strip, client: @client)
						if doc.valid? 
							doc.save
							# feedback to know which docs were created
							@created.push resp["list"][0]["subject"]
						else
							if doc.errors.full_messages[0] == "Title has already been taken" and doc.errors.full_messages.size == 1
								@errors.push "#{resp["list"][0]["subject"]} already exists"
							else
								@errors.push(doc.errors.full_messages)
							end
						end
						# @created and @error are displayed in HTML
					else
						@errors.push "#{row[0]} -- #{resp}"
					end
				end
			end
			# End reading CSV
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
