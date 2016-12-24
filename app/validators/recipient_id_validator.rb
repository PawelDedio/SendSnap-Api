class RecipientIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless RecipientIdValidator.is_valid?(record, value)
  end

  def self.is_valid?(record, value)
    if value.eql?(record.author_id)
      false
      return
    end

    user = record.author
    user.present? && !user.friend_ids.include?(value)
  end
end