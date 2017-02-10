require 'rails_helper'

RSpec.describe ChatMessagesController, type: :controller do
  describe 'routes test', type: :routing do
    it {
      should route(:get, 'chat_messages').to(action: :index)
    }

    it {
      should route(:post, 'chat_messages').to(action: :create)
    }

    it {
      uuid = '62342cab-3a74-4c7b-a38c-90dfea646817'
      should route(:put, "chat_messages/#{uuid}").to(action: :put, id: uuid)
    }
  end
end
