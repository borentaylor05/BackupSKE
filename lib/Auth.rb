class Auth

	# SKE is currently set to demo site!!!!
	@@current = {:username => ENV['SKE_USER'], :password => ENV['SKE_PASSWORD']}
	@@social = {:username => ENV['SKE_USER'], :password => ENV['SKE_PASSWORD']}
	@@new_auth = {:username => ENV['SKE_USER'], :password => ENV['SKE_PASSWORD']}
	@@fairpoint = { username: ENV['FP_USERNAME'], password: ENV['FP_PASSWORD'] }
	@@ww_coaches = { username: ENV['WWC_USERNAME'], password: ENV['WWC_PASSWORD'] }
	@@dev = { username: 'admin', password: 'admin' }
	@@uat = { username: 3170083, password: ENV['FP_PASSWORD'] }
	
	def self.new_auth
		@@new_auth
	end

	def self.uat
		@@uat
	end

	def self.social
		@@social
	end

	def self.ww_coaches
		@@ww_coaches
	end

	def self.fairpoint
		@@fairpoint
	end

	def self.dev
		@@dev
	end

	def self.current
		@@current
	end

end