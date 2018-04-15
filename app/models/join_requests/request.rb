# frozen_string_literal: true

class Request < JoinRequest
  belongs_to :invitee, class_name: 'User', inverse_of: :requests
end
