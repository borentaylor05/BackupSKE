class Document < ActiveRecord::Base
	validates :title, presence: true
	validates :title, uniqueness: true
	validates :body, presence: true

	belongs_to :client

end
