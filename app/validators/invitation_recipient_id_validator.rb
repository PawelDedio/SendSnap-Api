class InvitationRecipientIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless InvitationRecipientIdValidator.is_valid?(record, value)
  end

  def self.is_valid?(record, value)
    if value.eql?(record.author_id)
      false
      return
    end

    user = record.author
    if user.present?
      friend_ids = user.all_friends.map do |friend|
        friend.id
      end
      return !friend_ids.include?(value)
    end
    false
  end
end