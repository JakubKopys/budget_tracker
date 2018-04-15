# frozen_string_literal: true

class Invite < JoinRequest
  belongs_to :invitee, class_name: 'User', inverse_of: :invites
end
