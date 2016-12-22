# == Schema Information
#
# Table name: users
#
#  id                :uuid             not null, primary key
#  name              :string
#  display_name      :string
#  email             :string
#  terms_accepted    :boolean          default(FALSE)
#  role              :string           default("user")
#  blocked_at        :datetime
#  deleted_at        :datetime
#  auth_token        :string
#  token_expire_time :datetime
#  password_digest   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :display_name,
             :email,
             :terms_accepted,
             :role,
             :created_at,
             :updated_at
end
