class Order < ApplicationRecord
	has_many :items
	has_many :invitations
	belongs_to :user
	after_create_commit { BroadcastMessageJob.perform_later self }
	has_attached_file :menu, styles: { large:"500x500>", medium: "300x300#", thumb: "100x100#" }
  	validates_attachment_content_type :menu, content_type: /\Aimage\/.*\z/
end
