class Friendship < ApplicationRecord
	belongs_to :user
	belongs_to :friend, :class_name => "User"
	after_create_commit { BroadcastMessageJob.perform_later self }
end
