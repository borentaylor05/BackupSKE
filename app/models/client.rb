class Client < ActiveRecord::Base

	validates :name, presence: true

	has_many :documents

end