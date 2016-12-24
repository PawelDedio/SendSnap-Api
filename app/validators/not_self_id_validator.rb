class NotSelfIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('errors.messages.invalid', attribute: attribute)) unless NotSelfIdValidator.is_valid?(record, value)
  end

  def self.is_valid?(record, value)
    !value.eql?(record.author_id)
  end
end