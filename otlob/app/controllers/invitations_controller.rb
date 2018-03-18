class InvitationsController < ApplicationController
	def self.create(data)
		@invit = Invitation.new
		@invit.order_id=data['orderId']
		@invit.user_id=data['friends']
		@invit.status=0
		@invit.save
	end

end
