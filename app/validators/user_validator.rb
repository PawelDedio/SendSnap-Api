class UserValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless UserValidator.is_valid? value
  end

  def self.is_valid?(value)
    user = User.where(id: value)
    return user.present?
  end
end