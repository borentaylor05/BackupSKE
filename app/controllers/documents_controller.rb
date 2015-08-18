class DocumentsController < ApplicationController

	require 'Jive'

	def index
		@client = Client.find_by(name: params[:client].downcase)
		@docs = Document.where(client: @client)
	end

	def show
		@client = Client.find_by(name: params[:client].downcase)
		@doc = Document.find_by(id: params[:id], client: @client)
	end

	def upload
		@client = Client.find_by(name:params[:client])
	end

	def process_upload		
		client = Client.find_by(name: params[:client].downcase.strip)		
		jive = Jive.new('social')
		@errors, @created = [], []
		if client
			CSV.foreach(params[:file].path) do |row|
				if row[0]
					resp = jive.get_doc(row[0])
					if resp and resp["list"]
						html = jive.get_doc_html(resp)
						doc = Document.new(title: resp["list"][0]["subject"], body: html, client: client)
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
						@errors.push resp
					end
				end
			end
		else
			@errors.push "Client #{params[:client]} not found."
		end
		@error_count = @errors.size
		@created_count = @created.size
	end

	def api_get_documents
		client = Client.find_by(name: params[:client])
		if client
			respond({ status: 200, docs: Document.where(client: client) })
		else
			respond({ status: 400, error: "Client not found." })
		end
	end

end
