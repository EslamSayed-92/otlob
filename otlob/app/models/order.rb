class Order < ApplicationRecord
	has_many :items
	belongs_to :user

	has_attached_file :menu, styles: { large:"500x500>", medium: "300x300#", thumb: "100x100#" }
  	validates_attachment_content_type :menu, content_type: /\Aimage\/.*\z/
end
