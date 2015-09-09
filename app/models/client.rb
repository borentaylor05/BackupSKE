class Client < ActiveRecord::Base

	validates :name, presence: true

	has_many :documents

	def self.generate_token(length)
		token = Digest::SHA1.hexdigest([Time.now, rand].join)[0...length]
		while Client.exists?(token: token)
			token = Digest::SHA1.hexdigest([Time.now, rand].join)[0...length]
		end
		return token
	end

end
