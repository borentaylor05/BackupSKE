require 'Auth'

class Jive

	include HTTParty
	

	def initialize(instance)
		@proxy = URI(ENV["QUOTAGUARDSTATIC_URL"]) if ENV["QUOTAGUARDSTATIC_URL"]
		@options = {}
		if @proxy
			@options = {http_proxyaddr: @proxy.host,http_proxyport: @proxy.port, http_proxyuser: @proxy.user, http_proxypass: @proxy.password}
		end
		case instance
		when 'dev'
			@url = "http://localhost:8080/api/core/v3"
			@auth = Auth.dev
		when 'social'
			@url = "https://social.teletech.com/api/core/v3"
			@auth = Auth.social
		when 'wwc'
			@url = "https://weightwatchers.jiveon.com/api/core/v3"
			@auth = Auth.ww_coaches
			@options = {}
		end
		@options[:basic_auth] = @auth
		@options[:headers] = {'Content-Type' => 'application/json'}
		@user_template = {
		    emails: [ {
		      value: "",
		      type: "work",
		      primary: true,
		      jive_label: "Email"
		    } ],
		    jive: {
		      password: "",
		      username: ""
		    },
		    name: {
		      familyName: "",
		      givenName: ""
		    }
		}
	end

	def grab(resource)
	    json = HTTParty.get("#{@url}#{resource}", @options).body
	    if json 
	      clean(json)
	    else
	      puts json
	    end
	end

	def update(resource, params)
		#  puts url
		@options[:body] = params.to_json
		@options = { body: params.to_json, basic_auth: @auth }
		return HTTParty.put("#{@url}#{@resource}", @options)
	end

	def create(resource, params)
        @options[:body] = params.to_json
        json = HTTParty.post("#{@url}#{resource}", @options).parsed_response
        return json
    end

	def remove(resource)
		json = HTTParty.delete("#{@url}#{resource}", @options)
	end

	def clean(json)
		if json 
        	return JSON.parse(json.gsub!(/throw [^;]*;/, ''))
        else
        	return false
        end
    end

	def people_search(name)
    	grab("#{@url}/search/people?filter=search(#{name.gsub(/\s+/, ",")})", @auth)
  	end

  	def add_to_sec_group(group_id, jive_ids)
  		jive_ids.map! { |id| id = "#{@url}/people/#{id}" }
      	puts jive_ids
      	return self.create("/securityGroups/#{group_id}/members", jive_ids)
  	end

   	def get_all_users
   		si = 0
   		count = 0
		json = grab("/people?count=100&startIndex=#{si}")
		while json["list"] && json["list"].count > 0
			users = json["list"]
			users.each do |u|
				count += 1
			end
			si = si + 100
			json = grab("/people?count=100&startIndex=#{si}")
		end
		puts count
	end

	def get_documents(docs)
	end

	def get_doc(doc)
		doc = parse_link(doc)
		return grab("/contents?filter=entityDescriptor(102,#{doc})")
	end

	def get_doc_html(doc_resp)
		return doc_resp["list"][0]["content"]["text"]
	end


		def parse_link(doc)
			if doc.include?("http://") or doc.include?("https://")
				parts = doc.split("/")
				doc = parts[parts.length-1]
				if doc.include?('#')
					parts = doc.split('#')
					doc = parts[0]
				end				
			end
			doc = doc[4..-1] if doc.include?("DOC")
		end

end