class UserSerializer < ActiveModel::Serializer

  attributes :id,
             :email,
             :first_name,
             :last_name,
             :confirmed_at,
             :avatar_url

  has_many :videos

  def avatar_url
    object.avatar.url
  end
end
