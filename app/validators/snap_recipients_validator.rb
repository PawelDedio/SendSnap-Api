class SnapRecipientsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless SnapRecipientsValidator.is_valid?(record, value)
  end

  def self.is_valid?(record, value)
    return false if record.user.nil?
    value.size.eql? record.user.all_friends.where(id: value).size
  end
end