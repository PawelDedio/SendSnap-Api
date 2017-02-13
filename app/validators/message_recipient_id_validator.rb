class MessageRecipientIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless MessageRecipientIdValidator.is_valid?(record, value)
  end

  def self.is_valid?(record, value)
    return false if record.author.nil?
    record.author.all_friends.where(id: value).size == 1
  end
end