class Document < ActiveRecord::Base
	validates :title, presence: true
	validates :title, uniqueness: true
	validates :link, uniqueness: true
	validates :link, presence: true
	validates :body, presence: true

	belongs_to :client

end
