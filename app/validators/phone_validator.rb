class PhoneValidator < ActiveModel::Validator
  def validate(record)
    field = options[:field]
    phone_validator(record, field)
  end

  private

  def phone_validator(record, field)
    number = record.send(field)
    digits = number.scan(/\d/).size

    unless (digits >= 10 && digits <= 11) && number.match?(/\A[(]?(\d{2})[)]?[\ ]?(\d{4,5})[-\ ]?(\d{4})\z/)
      return record.errors.add(field, I18n.t('phone_validator.invalid_registration'))
    end

    false
  end
end